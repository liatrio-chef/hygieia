#
# Cookbook Name:: hygieia-liatrio
# Recipe:: apache2
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

# need this so apache can access the directory
# /home/vagrant/Hygieia/UI/dist 
# it is a symlink to /var/www/hygieia.local
directory '/home/vagrant' do
  mode '0755'
end

# ln -s /home/vagrant/Hygieia/UI/dist /var/www/hygieia.local
link '/var/www/hygieia.local' do
  to '/home/vagrant/Hygieia/UI/dist'
end

web_app 'hygieia' do
   template 'hygieia.conf.erb'
end
