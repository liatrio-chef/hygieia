#
# Cookbook Name:: hygieia-liatrio
# Recipe:: mongodb
#
# Author: Drew Holt <drew@liatrio.com>
#

# setup mongodb repo
cookbook_file '/etc/yum.repos.d/mongodb-3.2.repo' do
  source 'mongodb-3.2.repo'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# install mongodb
%w(mongodb-org).each do |pkg|
  package pkg do
    action :install
    not_if 'which mongo'
  end
end

cookbook_file '/etc/mongod.conf' do
  source 'mongod.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# start and enable mongodb
service 'mongod' do
  action [:enable, :start]
end

cookbook_file '/tmp/createdb.js' do
  source 'createdb.js'
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  mode '0644'
  action :create
end

# create mongo db user
execute 'create-mongo-db-user' do
  command 'mongo dashboard /tmp/createdb.js'
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  not_if { ::File.exist?('/tmp/createdb.done') }
end

# create lock file, should make this into a mongodb command
file '/tmp/createdb.done' do
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  action :create
end
