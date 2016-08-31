#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe "java"

# install git
package "git"

# fix git to use https instead of git uri, breaks bower
execute 'git-use-https' do
  command 'git config -f /home/vagrant/.gitconfig url."https://".insteadOf git://'
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
end

# download maven 3.3.9 required by Hygieia
remote_file '/home/vagrant/apache-maven-3.3.9-bin.tar.gz' do
  source 'http://apache.mirrors.ionfish.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz'
  owner 'vagrant'
  group 'vagrant'
  mode '644'
  action :create
end

# untar maven
execute 'untar_apache-maven' do
  command 'tar -C /home/vagrant -zxvf /home/vagrant/apache-maven-3.3.9-bin.tar.gz'
  user 'vagrant'
  group 'vagrant'
  not_if do ::File.exists?('/home/vagrant/apache-maven-3.3.9') end
  notifies :run, 'execute[set_path]', :immediately
end

# add maven to our path
execute 'set_path' do
  command 'echo "export PATH=/home/vagrant/apache-maven-3.3.9/bin:$PATH" >> /home/vagrant/.bashrc'
  user 'vagrant'
  group 'vagrant'
  not_if ('grep apache-maven-3.3.9 /home/vagrant/.bashrc')
end

# git clone hygieia 
execute 'git-clone-hygieia' do
  command 'git clone https://github.com/Liatrio/Hygieia.git'
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  not_if do ::File.exists?('/home/vagrant/Hygieia') end
end

# mvn clean install - cwd is not working, fix this
template '/home/vagrant/dashboard.properties' do
  source 'home/vagrant/dashboard.properties.erb'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  variables ({})
end

# use mvn --pl to only compile what we need from attribute
# [:hygieia_liatrio][:collectors] but need to fix issue
# joining this array into a string
# "--pl #{mvn_collectors} " 
#
# also need to remove skip tests below
execute "mvn-clean-install" do
  command "sudo -u vagrant PWD=/home/vagrant/Hygieia " \
    "/home/vagrant/apache-maven-3.3.9/bin/mvn -Dmaven.test.failure.ignore=true -Dmaven.test.skip=true " \
    "--quiet install"
  user "root"
  group "root"
  cwd "/home/vagrant/Hygieia"
  #not_if "ls /home/vagrant/Hygieia/api/target | grep .jar"
end

# add systemd service files for each collector, enable and start them
node[:hygieia_liatrio][:collectors].each do |hygieia_service|
  # instead of using the block above, it would be better to compile only
  # what we need. however this fails trying to find core for the 
  # compile of sub modules
  #execute "mvn-clean-install-#{hygieia_serivce}" do
  #  command "PWD=/home/vagrant/Hygieia/#{hygieia_service} /home/vagrant/apache-maven-3.3.9/bin/mvn -Dmaven.test.failure.ignore=true --quiet install"
  #  user "vagrant"
  #  group "vagrant"
  #  cwd "/home/vagrant/Hygieia/#{hygieia_service}"
  #  not_if "ls /home/vagrant/Hygieia/#{hygieia_service}/target | grep .jar"
  #end

#node.default['mvn_collectors'] = #{node[:hygieia_liatrio][:collectors]}.join(",")
  if hygieia_service != "core" 
  cookbook_file "/etc/systemd/system/hygieia-#{hygieia_service}.service" do
    source "etc/systemd/system/hygieia-#{hygieia_service}.service"
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

  service "hygieia-#{hygieia_service}" do
    action [ :enable, :start ]
  end
  end
end
