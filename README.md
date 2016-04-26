hygieia-liatrio Cookbook
========================
A cookbook to compile hygieia with github, bitbucket, jira, jenkins, udeploy, and sonar collectors on CentOS 7.

Supported Platforms
-------------------

CentOS 7

Requirements
------------
Ensure the ChefDK is installed from https://downloads.chef.io/chef-dk/

Ensure the vagrant-berkshelf plugin is installed: `vagrant plugin install vagrant-berkshelf`

Usage
-----
`vagrant up` will install mongodb, create a mongo db with a user, build hygieia, and start on boot. It may be needed to ssh to the VM and `cd ~/Hygieia; mvn clean install` multiple times due to network issues pulling down artifacts, also then restart all of the collectors via `cd /etc/systemd/system; sudo systemctl restart hygieia-*`.

Attributes
----------
```
default[:hygieia_liatrio][:dbname]		= 'dashboard'
default[:hygieia_liatrio][:dbhost]		= '127.0.0.1'
default[:hygieia_liatrio][:dbport]		= '27017'
default[:hygieia_liatrio][:dbusername]		= 'db'
default[:hygieia_liatrio][:dbpassword]		= 'dbpass'
default[:hygieia_liatrio][:jenkins_url]		= 'http://192.168.100.10:8080/'
default[:hygieia_liatrio][:udeploy_url]		= 'http://192.168.100.40:8080'
default[:hygieia_liatrio][:udeploy_username]	= 'admin'
default[:hygieia_liatrio][:udeploy_password]	= 'password'
default[:hygieia_liatrio][:sonar_url]		= 'http://192.168.100.10:9000/'
default[:hygieia_liatrio][:stash_url]		= 'http://192.168.100.60:7990/'
```

License and Authors
-------------------
Authors: Drew Holt <drew@liatrio.com>
