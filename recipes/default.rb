#
# Cookbook Name:: hygieia-liatrio
# Recipe:: default
#
# Author: Drew Holt <drew@liatrio.com>
#

# add java
include_recipe 'java' do
  not_if 'which java'
end

# install git
package 'git' do
  not_if 'which git'
end

# install bzip2
package 'bzip2' do
  not_if 'which bzip2'
end

# install yum maven from epel dchen
remote_file '/etc/yum.repos.d/epel-apache-maven.repo' do
  source 'http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo'
  user 'root'
  group 'root'
  mode 0o644
  action :create_if_missing
end

# install maven 3.3.9
yum_package 'apache-maven' do
  version '3.3.9-3.el7'
  not_if 'which mvn'
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

# Add Hygieia dashboard.properties for collector config
template "#{node['hygieia_liatrio']['home']}/dashboard.properties" do
  source 'dashboard.properties.erb'
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  mode '0644'
end

# clone Hygieia
git '/vagrant/Hygieia' do
  repository 'https://github.com/liatrio/Hygieia.git'
  revision 'master'
  action :sync
  user node['hygieia_liatrio']['user']
  not_if 'ls -d /vagrant/Hygieia'
end

# pull api, core, and collectors from maven central
jar = [
  'https://repo1.maven.org/maven2/com/capitalone/dashboard/api/2.0.3/api-2.0.3.jar',
  # 'https://repo1.maven.org/maven2/com/capitalone/dashboard/core/2.0.3/core-2.0.3.jar',
  # 'https://repo1.maven.org/maven2/com/capitalone/dashboard/subversion-collector/2.0.3/subversion-collector-2.0.3.jar',
  'https://repo1.maven.org/maven2/com/capitalone/dashboard/github-scm-collector/2.0.3/github-scm-collector-2.0.3.jar',
  'https://repo1.maven.org/maven2/com/capitalone/dashboard/bitbucket-scm-collector/2.0.3/bitbucket-scm-collector-2.0.3.jar',
  # 'https://repo1.maven.org/maven2/com/capitalone/dashboard/chat-ops-collector/2.0.3/chat-ops-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/versionone-feature-collector/2.0.3/versionone-feature-collector-2.0.3.jar',
  'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/jira-feature-collector/2.0.3/jira-feature-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/xldeploy-deployment-collector/2.0.3/xldeploy-deployment-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/udeploy-deployment-collector/2.0.3/udeploy-deployment-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/aws-cloud-collector/2.0.3/aws-cloud-collector-2.0.3.jar',
  'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/sonar-codequality-collector/2.0.3/sonar-codequality-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/jenkins-cucumber-test-collector/2.0.3/jenkins-cucumber-test-collector-2.0.3.jar',
  'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/jenkins-build-collector/2.0.3/jenkins-build-collector-2.0.3.jar',
  # 'http://search.maven.org/remotecontent?filepath=com/capitalone/dashboard/bamboo-build-collector/2.0.3/bamboo-build-collector-2.0.3.jar'
]

# download the jar files
jar.each do |download_jar|
  execute "download jar #{download_jar}" do
    command "wget -q --content-disposition #{download_jar}"
    cwd node['hygieia_liatrio']['home']
    user node['hygieia_liatrio']['user']
    group node['hygieia_liatrio']['group']
    jar_filename = download_jar.split('/')[-1]
    not_if "ls #{node['hygieia_liatrio']['home']}/#{jar_filename}"
  end
end

# # load api first
# template '/etc/systemd/system/hygieia-core-2.0.3.jar.service' do
#   source 'etc/systemd/system/hygieia-core-2.0.3.jar.service'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   variables(jar_home: node['hygieia_liatrio']['home'],
#             user: node['hygieia_liatrio']['user'])
#   action :create
# end
#
# # changes in /etc/systemd/system need this
# execute 'systemctl daemon-reload' do
#   command 'systemctl daemon-reload'
#   user 'root'
# end
#
# # start the core service
# service 'hygieia-core-2.0.3.jar' do
#   action [:enable, :start]
# end

# add systemd service files for each collector, enable and start them
node['hygieia_liatrio']['collectors'].each do |hygieia_service|
  template "/etc/systemd/system/hygieia-#{hygieia_service}.service" do
    source 'hygieia-.service'
    owner 'root'
    group 'root'
    mode '0644'
    variables(jar_home: node['hygieia_liatrio']['home'],
              user: node['hygieia_liatrio']['user'],
              hygieia_service: hygieia_service)
    action :create
  end
end

# changes in /etc/systemd/system need this
execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  user 'root'
end

# enable each collector and boot and start immediately
node['hygieia_liatrio']['collectors'].each do |hygieia_service|
  service "hygieia-#{hygieia_service}" do
    action [:enable, :start]
  end
end

# build hygieia-ui
execute 'build hygieia-ui' do
  command 'sudo -u vagrant sh -c "source /home/vagrant/.bashrc && npm install && bower install && gulp build"'
  user 'vagrant'
  user 'vagrant'
  cwd '/vagrant/Hygieia/UI'
  notifies :create, 'ruby_block[set the ui_built flag]', :immediately
  not_if { node.attribute?('ui_built') || ::File.file?("#{node[:hygieia_liatrio][:home]}/ui_built") }
end

# set the ui_built flag
ruby_block 'set the ui_built flag' do
  block do
    node.set['ui_built'] = true
    Chef::Config[:solo] ? ::FileUtils.touch("#{node['hygieia_liatrio']['home']}/ui_built") : node.save
  end
  action :nothing
end

# add UI systemd service file
template '/etc/systemd/system/hygieia-ui.service' do
  source 'hygieia-ui.service'
  owner 'root'
  group 'root'
  mode '0644'
  variables(jar_home: node['hygieia_liatrio']['home'],
            user: node['hygieia_liatrio']['user'])
  action :create
end

# changes in /etc/systemd/system need this
execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  user 'root'
end

# start the hygieia UI
service 'hygieia-ui' do
  action [:enable, :start]
end
