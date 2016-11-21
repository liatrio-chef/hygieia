#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Author: Drew Holt <drew@liatrio.com>
#

# add java
include_recipe 'java'

# install git
package 'git'

package 'bzip2'

# install yum maven from epel dchen
remote_file '/etc/yum.repos.d/epel-apache-maven.repo' do
  source 'http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo'
  user 'root'
  group 'root'
  mode 0o644
  action :create
end

# install maven 3.3.9
yum_package 'apache-maven' do
  version '3.3.9-3.el7'
end

# create hygieia group
group 'create hygieia group' do
  group_name node['hygieia_liatrio']['group']
  action :create
end

# create hygieia user
user 'create hygieia user' do
  username node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  home node['hygieia_liatrio']['home']
  action :create
  manage_home true
end

# ensure hygieia user home directory is 755
directory node['hygieia_liatrio']['home'] do
  mode 0o755
end

# clone Hygieia
git "#{node['hygieia_liatrio']['home']}/Hygieia" do
  repository 'https://github.com/Liatrio/Hygieia.git'
  revision 'master'
  action :sync
  user node['hygieia_liatrio']['user']
end

# Add Hygieia dashboard.properties for collector config
template "#{node['hygieia_liatrio']['home']}/dashboard.properties" do
  source 'dashboard.properties.erb'
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  mode '0644'
end

# use mvn --pl to only compile what we need from attribute
# [:hygieia_liatrio][:collectors] but need to fix issue
# joining this array into a string
# "--pl #{mvn_collectors} "
#
# also need to remove skip tests below
# XXX
# execute "mvn-clean-install" do
#  command "sudo -u #{node["hygieia_liatrio"]["user"]} PWD=#{node["hygieia_liatrio"]["home"]}/Hygieia " \
#    "mvn -Dmaven.test.failure.ignore=true -Dmaven.test.skip=true " \
#    "--quiet install"
#  user "root"
#  group "root"
#  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia"
#  #not_if "ls #{node["hygieia_liatrio"]["home"]}/Hygieia/api/target | grep .jar"
# end

# copy compiled jars to hygieia home directory
# execute "copy jars" do
#  command "cp */*/*.jar .."
#  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia"
#  user node["hygieia_liatrio"]["user"]
#  not_if "ls #{node["hygieia_liatrio"]["home"]}/*.jar"
# end

# XXX
# add systemd service files for each collector, enable and start them
# node['hygieia_liatrio']['collectors'].each do |hygieia_service|
#  # instead of using the block above, it would be better to compile only
#  # what we need. however this fails trying to find core for the
#  # compile of sub modules
#  # execute "mvn-clean-install-#{hygieia_serivce}" do
#  #  command "PWD=#{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service} #{node["hygieia_liatrio"]["home"]}/apache-maven-3.3.9/bin/mvn -Dmaven.test.failure.ignore=true --quiet install"
#  #  user node["hygieia_liatrio"]["user"]
#  #  group node["hygieia_liatrio"]["group"]
#  #  cwd "#{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service}"
#  #  not_if "ls #{node["hygieia_liatrio"]["home"]}/Hygieia/#{hygieia_service}/target | grep .jar"
#  # end
#
#  # node.default['mvn_collectors'] = #{node[:hygieia_liatrio][:collectors]}.join(",")
#  next unless hygieia_service != 'core'
#  template "/etc/systemd/system/hygieia-#{hygieia_service}.service" do
#    source "etc/systemd/system/hygieia-#{hygieia_service}.service"
#    owner 'root'
#    group 'root'
#    mode '0644'
#    variables(jar_home: node['hygieia_liatrio']['home'],
#              user: node['hygieia_liatrio']['user'])
#    action :create
#  end
#
#  service "hygieia-#{hygieia_service}" do
#    # XXXaction [ :enable, :start ]
#    action [:enable]
#  end
# end
