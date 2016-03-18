#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Copyright 2016, liatrio
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

## install latest apache-maven from http://maven.apache.org/ here, setup $PATH

## git clone hygieia and mvn clean install

template '/home/vagrant/projects/Hygieia/api/target/dashboard.properties' do
  source   'home/vagrant/projects/Hygieia/api/target/dashboard.properties.erb'
  mode     '0666'
  variables({})
end

cookbook_file '/etc/systemd/system/hygieia-api.service' do
  source 'etc/systemd/system/hygieia-api.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-api" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-github-collector.service' do
  source 'etc/systemd/system/hygieia-github-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-github-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-jenkins-build-collector.service' do
  source 'etc/systemd/system/hygieia-jenkins-build-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-jenkins-build-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-sonar-codequality-collector.service' do
  source 'etc/systemd/system/hygieia-sonar-codequality-collector.service'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service "hygieia-sonar-codequality-collector" do
  action [ :enable, :start ]
end

cookbook_file '/etc/systemd/system/hygieia-udeploy-deployment-collector.service' do
  source 'etc/systemd/system/hygieia-udeploy-deployment-collector.service'
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

