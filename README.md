hygieia-liatrio Cookbook
========================
A cookbook to compile hygieia with github, bitbucket, jira, jenkins, udeploy, and sonar collectors on CentOS 7.

Supported Platforms
-------------------
CentOS 7

Requirements
------------
Vagrant 1.8.1

Ensure the ChefDK is installed from https://downloads.chef.io/chef-dk/

Ensure the vagrant-berkshelf plugin is installed: `vagrant plugin install vagrant-berkshelf`

Usage
-----
A baked version of this cookbook configured and with dummy data can be found here: https://github.com/liatrio-chef/hygieia-petclinic-demo-baked

A baked version of this cookbook uncofnigured can be found here:
https://github.com/liatrio-chef/hygieia-dev-baked

To get started:
```
git clone https://github.com/liatrio-chef/hygieia-liatrio.git
cd hygieia-liatrio
vagrant up
```

On the first vagrant up the chef provisioner will install mongodb, create a mongo db with user db and password dbpass, compile hygieia, and start on boot. 

If maven fails to compile itt may be needed to `vagrant ssh` to the VM and then run;
```
cd ~/Hygieia
mvn clean install
``` 
This may need to be done mulltiple times as there are network issues when maven tries to mirror artifacts through Archiva. Once maven has compiled successfully, restart the Hygieia collectors: `cd /etc/systemd/system; sudo systemctl restart hygieia-*`.

Once successful, point your browser to http://localhost:13000/ or http://192.168.1.10:3000/ if you are using the same networking in the supplied Vagrantfile from this repo.

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
