#
# Cookbook Name:: hygieia-liatrio
# Recipe:: mongodb_sample_data
#
# Author: Drew Holt <drew@liatrio.com>
#

# needed to compile ruby gems
package "gcc"

remote_directory '/home/vagrant/hygieia_mongod' do
  source 'hygieia_mongod'
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  action :create
  cookbook node['hygieia_liatrio']['parent_cookbook']
end

execute 'import hygieia_mongod' do
  command 'mongorestore hygieia_mongod'
  cwd '/home/vagrant'
  user 'vagrant'
  group 'vagrant'
  not_if do ::File.exists?('/home/vagrant/hygieia_mongod.done') end
end

file '/home/vagrant/hygieia_mongod.done' do
  user 'vagrant'
  group 'vagrant'
  action :create
end

# install for update_timestamps.rb
package 'ruby'
package 'ruby-devel'

gem_package 'mongo'

template 'home/vagrant/update_timestamps.rb' do
  path '/home/vagrant/update_timestamps.rb'
  owner 'vagrant'
  group 'vagrant'
  mode '755'
end

cron 'update mongo timestamps hourly' do
  minute '35'
  command '/usr/bin/ruby /home/vagrant/update_timestamps.rb >> /home/vagrant/update_timestamps.log'
  user 'vagrant'
end

# run update_timestamps.rb at each boot
cookbook_file 'etc/rc.d/rc.local' do
  path '/etc/rc.d/rc.local'
  owner 'root'
  group 'root'
  mode '755'
end

execute 'update mongo data in chef run' do
  command '/usr/bin/ruby /home/vagrant/update_timestamps.rb >> /home/vagrant/update_timestamps.log'
  user 'vagrant'
end
