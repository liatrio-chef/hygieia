#
# Cookbook Name:: hygieia-liatrio
# Recipe:: apache2
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

web_app 'hygieia' do
   template 'hygieia.conf.erb'
end
