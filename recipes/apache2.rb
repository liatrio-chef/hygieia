#
# Cookbook Name:: hygieia-liatrio
# Recipe:: apache2
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe 'apache2'

web_app 'hygieia' do
   template 'hygieia.conf.erb'
end
