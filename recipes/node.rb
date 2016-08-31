#
# Cookbook Name:: hygieia-liatrio
# Recipe:: node
#
# Author: Drew Holt <drew@liatrio.com>
#

# install epel
#package "epel-release"

# install nodejs and npm
#%w{ nodejs npm }.each do |pkg|
#  package pkg do
#    action :install
#  end
#end

# add node yum repo
execute "add_node6_repo" do
  command "curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -"
  not_if do ::File.exists?('/etc/yum.repos.d/nodesource-el.repo') end
end

# install node.js via yum
package "nodejs"

# install bower (1st time)
execute 'install-bower-1st' do
  command 'npm install -g bower'
  user 'root'
  group 'root'
end

# install bower (2nd time), needed to run twice for some reason? fix this
execute 'install-bower-2nd' do
  command 'npm install -g bower'
  user 'root'
  group 'root'
  #not_if ('which bower')
end

# install gulp
execute 'install-gulp' do
  command 'npm install -g gulp'
  user 'root'
  group 'root'
  not_if ('which gulp')
end
