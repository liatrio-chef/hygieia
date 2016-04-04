#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Authors:: Drew Holt <drew@liatrio.com>
#

template '/home/vagrant/projects/Hygieia/api/target/dashboard.properties' do
  source   'home/vagrant/projects/Hygieia/api/target/dashboard.properties.erb'
  mode     '0666'
  variables({})
end

cookbook_file '/etc/init/hygieia-github-collector.conf' do
  source 'etc/init/hygieia-github-collector.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-github-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/init/hygieia-jenkins-build-collector.conf' do
  source 'etc/init/hygieia-jenkins-build-collector.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-jenkins-build-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/init/hygieia-sonar-codequality-collector.conf' do
  source 'etc/init/hygieia-sonar-codequality-collector.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-sonar-codequality-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/init/hygieia-udeploy-deployment-collector.conf' do
  source 'etc/init/hygieia-udeploy-deployment-collector.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-udeploy-deployment-collector" do
  action [ :enable, :start ]
end

service "hygieia-api" do
  action [ :restart ]
end

