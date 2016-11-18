#
# Cookbook Name:: hygieia-liatrio
# Recipe:: apache2
#
# Author: Drew Holt <drew@liatrio.com>
#

include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# need this so apache can access the directory
# #{node["hygieia_liatrio"]["home"]}/Hygieia/UI/dist
# it is a symlink to /var/www/hygieia.local
directory node["hygieia_liatrio"]["home"] do
  mode "0755"
end

# ln -s #{node["hygieia_liatrio"]["home"]}/Hygieia/UI/dist /var/www/hygieia.local
link "/var/www/hygieia.local" do
  to node["hygieia_liatrio"]["symlink"]
end

web_app "hygieia" do
  template "hygieia.conf.erb"
end
