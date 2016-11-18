#
# Cookbook Name:: hygieia-liatrio
# Recipe:: mongodb_sample_data
#
# Author: Drew Holt <drew@liatrio.com>
#

# needed to compile ruby gems
package "gcc"

remote_directory "#{node["hygieia_liatrio"]["home"]}/hygieia_mongod" do
  source "hygieia_mongod"
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  mode "0755"
  action :create
  cookbook node["hygieia_liatrio"]["parent_cookbook"]
end

execute "import hygieia_mongod" do
  command "mongorestore hygieia_mongod"
  cwd node["hygieia_liatrio"]["home"]
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  not_if { ::File.exists?("#{node["hygieia_liatrio"]["home"]}/hygieia_mongod.done") }
end

file "#{node["hygieia_liatrio"]["home"]}/hygieia_mongod.done" do
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  action :create
end

# install for update_timestamps.rb
package "ruby"
package "ruby-devel"

gem_package "mongo"

template "#{node["hygieia_liatrio"]["home"]}/update_timestamps.rb" do
  source "update_timestamps.rb.erb"
  user node["hygieia_liatrio"]["user"]
  group node["hygieia_liatrio"]["group"]
  mode "755"
end

cron "update mongo timestamps hourly" do
  minute "35"
  command "/usr/bin/ruby #{node["hygieia_liatrio"]["home"]}/update_timestamps.rb >> #{node["hygieia_liatrio"]["home"]}/update_timestamps.log"
  user node["hygieia_liatrio"]["user"]
end

# run update_timestamps.rb at each boot
cookbook_file "etc/rc.d/rc.local" do
  path "/etc/rc.d/rc.local"
  owner "root"
  group "root"
  mode "755"
end

execute "update mongo data in chef run" do
  command "/usr/bin/ruby #{node["hygieia_liatrio"]["home"]}/update_timestamps.rb >> #{node["hygieia_liatrio"]["home"]}/update_timestamps.log"
  user node["hygieia_liatrio"]["user"]
end
