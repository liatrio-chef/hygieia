#
# Cookbook Name:: hygieia-liatrio
# Recipe:: node
#
# Author: Drew Holt <drew@liatrio.com>
#

version = 'v5.4.1'
node.set['nvm']['nvm_install_test']['version'] = version

include_recipe 'nvm'

nvm_install version do
  from_source false
  user 'vagrant'
  alias_as_default true
  action :create
end

# install bower and gulp globablly
execute 'install bower gulp' do
  command 'sudo -u vagrant sh -c "source /home/vagrant/.bashrc && npm install -g bower gulp"'
  user 'root'
  group 'root'
  cwd '/home/vagrant'
  not_if 'sudo -u vagrant sh -c "source /home/vagrant.bashrc && which bower"'
end
