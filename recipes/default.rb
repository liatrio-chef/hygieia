#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe "java"

# setup mongodb repo
cookbook_file '/etc/yum.repos.d/mongodb-3.2.repo' do
  source 'etc/yum.repos.d/mongodb-3.2.repo'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# install mongodb
%w{ mongodb-org }.each do |pkg|
  package pkg do
    action :install
  end
end

# start and enable mongodb
service "mongod" do
  action [ :enable, :start ]
end

# create lock file, should make this into a mongodb command
file '/home/vagrant/createdb.done' do
  user 'vagrant'
  group 'vagrant'
  action :create
end

# create mongo db user
execute 'create-mongo-db-user' do
  command 'mongo dashboard /home/vagrant/createdb.js'
  user 'vagrant'
  group 'vagrant'
  not_if do ::File.exists?('/home/vagrant/createdb.done') end
end

# ensure git and epel-release are installed
%w{ git epel-release }.each do |pkg|
  package pkg do
    action :install
  end
end

# install nodejs and npm
%w{ nodejs npm }.each do |pkg|
  package pkg do
    action :install
  end
end

# install bower (1st time)
execute 'install-bower-1st' do
  command 'npm install -g bower'
  user 'root'
  group 'root'
  not_if ('which bower')
end

# install bower (2nd time), needed to run twice for some reason?
execute 'install-bower-2nd' do
  command 'npm install -g bower'
  user 'root'
  group 'root'
  not_if ('which bower')
end

# pull down latest maven, 3.3.9 required by Hygieia
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
  command 'git clone https://github.com/capitalone/Hygieia.git'
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant'
  not_if do ::File.exists?('/home/vagrant/Hygieia') end
end

# mvn clean install
execute 'mvn-clean-install' do
  command 'PATH=/home/vagrant/apache-maven-3.3.9/bin:$PATH mvn clean install'
  user 'vagrant'
  group 'vagrant'
  cwd '/home/vagrant/Hygieia'
  not_if do ::File.exists?('/home/vagrant/Hygieia/api/target/api.jar') end
  ignore_failure true
end

# Banner to say Rally is coming soon
cookbook_file '/home/vagrant/Hygieia/UI/src/app/dashboard/views/widget.html' do
  source 'home/vagrant/Hygieia/UI/src/app/dashboard/views/widget.html'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create
end

# Replace logo until we create a new theme
cookbook_file '/home/vagrant/Hygieia/UI/src/assets/img/hygieia_b.png ' do
  source 'home/vagrant/Hygieia/UI/src/assets/img/hygieia_b.png '
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create
end

cookbook_file '/home/vagrant/dashboard.properties' do
  source 'home/vagrant/dashboard.properties'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create
end

cookbook_file '/etc/systemd/system/hygieia-api.service' do
  source 'etc/systemd/system/hygieia-api.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-api" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-github-collector.service' do
  source 'etc/systemd/system/hygieia-github-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-github-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-jenkins-build-collector.service' do
  source 'etc/systemd/system/hygieia-jenkins-build-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-jenkins-build-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-sonar-codequality-collector.service' do
  source 'etc/systemd/system/hygieia-sonar-codequality-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-sonar-codequality-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-udeploy-deployment-collector.service' do
  source 'etc/systemd/system/hygieia-udeploy-deployment-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
service "hygieia-udeploy-deployment-collector" do

  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-stash-scm-collector.service' do
  source 'etc/systemd/system/hygieia-stash-scm-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-stash-scm-collector" do
  action [ :enable, :start ]
end

service "hygieia-api" do
  action [ :restart ]
end

