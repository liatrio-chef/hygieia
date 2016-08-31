#
# Cookbook Name:: hygieia-liatrio
# Recipe:: mongodb
#
# Author: Drew Holt <drew@liatrio.com>
#

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

cookbook_file '/etc/mongod.conf' do
  source 'etc/mongod.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# start and enable mongodb
service "mongod" do
  action [ :enable, :start ]
end

cookbook_file '/home/vagrant/createdb.js' do
  source 'home/vagrant/createdb.js'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create
end

# create mongo db user
execute 'create-mongo-db-user' do
  command 'mongo dashboard /home/vagrant/createdb.js'
  user 'vagrant'
  group 'vagrant'
  not_if do ::File.exists?('/home/vagrant/createdb.done') end
end

# create lock file, should make this into a mongodb command
file '/home/vagrant/createdb.done' do
  user 'vagrant'
  group 'vagrant'
  action :create
end
