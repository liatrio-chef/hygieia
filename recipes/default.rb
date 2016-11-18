#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe "java"

# install git
package "git"

# install yum maven from epel dchen
remote_file "/etc/yum.repos.d/epel-apache-maven.repo" do
  source "http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo"
  user "root"
  group "root"
  mode 0644
  action :create
end

# install maven 3.3.9
yum_package "apache-maven" do
  version "3.3.9-3.el7"
end

# create hygieia group
group "create hygieia group" do
  group_name node["hygieia_liatrio"]["group"]
  action :create
end

# create hygieia user
user "create hygieia user" do
  username node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  home node["hygieia_liatrio"]["home"]
  action :create
  manage_home true
end

directory node["hygieia_liatrio"]["home"] do
  mode 0755
end

# XXX fix this
#execute "git use https" do
#  command "git config -f #{node["hygieia_liatrio"]["home"]}/.gitconfig url."https://".insteadOf git://"
#  user node["hygieia_liatrio"]["user"]
#  group node["hygieia_liatrio"]["group"]
#  cwd node["hygieia_liatrio"]["home"]
#end

# git clone hygieia
execute "git-clone-hygieia" do
  command "git clone https://github.com/Liatrio/Hygieia.git"
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  cwd node["hygieia_liatrio"]["home"]
  not_if { ::File.exists?("#{node["hygieia_liatrio"]["home"]}/Hygieia") }
end

# mvn clean install - cwd is not working, fix this
template "#{node["hygieia_liatrio"]["home"]}/dashboard.properties" do
  source "dashboard.properties.erb"
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  mode "0644"
  variables ({})
end

# use mvn --pl to only compile what we need from attribute
# [:hygieia_liatrio][:collectors] but need to fix issue
# joining this array into a string
# "--pl #{mvn_collectors} "
#
# also need to remove skip tests below
execute "mvn-clean-install" do
  command "sudo -u #{node["hygieia_liatrio"]["user"]} PWD=#{node["hygieia_liatrio"]["home"]}/Hygieia " \
    "mvn -Dmaven.test.failure.ignore=true -Dmaven.test.skip=true " \
    "--quiet install"
  user "root"
  group "root"
  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia"
  #not_if "ls #{node["hygieia_liatrio"]["home"]}/Hygieia/api/target | grep .jar"
end

# add systemd service files for each collector, enable and start them
node["hygieia_liatrio"]["collectors"].each do |hygieia_service|
  # instead of using the block above, it would be better to compile only
  # what we need. however this fails trying to find core for the
  # compile of sub modules
  #execute "mvn-clean-install-#{hygieia_serivce}" do
  #  command "PWD=#{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service} #{node["hygieia_liatrio"]["home"]}/apache-maven-3.3.9/bin/mvn -Dmaven.test.failure.ignore=true --quiet install"
  #  user node["hygieia_liatrio"]["user"]
  #  group node["hygieia_liatrio"]["group"]
  #  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service}"
  #  not_if "ls #{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service}/target | grep .jar"
  #end

#node.default['mvn_collectors'] = #{node[:hygieia_liatrio][:collectors]}.join(",")
  if hygieia_service != "core"
    template "/etc/systemd/system/hygieia-#{hygieia_service}.service" do
      source "etc/systemd/system/hygieia-#{hygieia_service}.service"
      owner "root"
      group "root"
      mode "0644"
      variables ({
      :jar_home => node["hygieia_liatrio"]["home"],
      :user => node["hygieia_liatrio"]["user"]
      })
      action :create
    end

    service "hygieia-#{hygieia_service}" do
      action [ :enable, :start ]
    end
  end
end

execute "copy jars" do
  command "cp */*/*.jar .."
  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia"
  user node["hygieia_liatrio"]["user"]
  not_if "ls #{node["hygieia_liatrio"]["home"]}/*.jar"
end
