#
# Cookbook Name:: hygieia-liatrio
# Recipe:: apache2
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

execute 'copy_hygieia_ui_to_apache' do
  command 'cp -pr /home/vagrant/Hygieia/UI/dist/ /var/www/hygieia.local'
  user 'root'
  group 'root'
  not_if do ::File.directory?('/var/www/hygieia.local') end
end

web_app 'hygieia' do
   template 'hygieia.conf.erb'
end
