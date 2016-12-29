hygieia-liatrio Cookbook
========================
A cookbook to assemble [Hygieia](http://github.com/capitaone/Hygieia) via Chef on CentOS 7 with support for extending UI.

Supported Platforms
-------------------
CentOS 7

Requirements
------------
[Vagrant 1.8.4](http://vagrantup.com/)

[ChefDK 0.16.28](https://downloads.chef.io/chef-dk/)

vagrant-berkshelf (5.0.0): `vagrant plugin install vagrant-berkshelf`

Usage
-----
A baked version of this cookbook configured with dummy data can only be found here: https://github.com/liatrio-chef/hygieia-petclinic-demo-baked

A baked version of this cookbook uncofnigured can be found here:
https://github.com/liatrio-chef/hygieia-dev-baked

To get started:
```
git clone https://github.com/liatrio-chef/hygieia-liatrio.git
cd hygieia-liatrio
vagrant up
```

On the first vagrant up the Chef provisioner will install mongodb, create a mongo db with user db and password dbpass, compile Hygieia, and start on boot.

If Chef run fails it may do to network. Simply run another `vagrant provision`. Once the provision has finished successfully, restart the Hygieia collectors: `cd /etc/systemd/system; sudo systemctl restart hygieia-*`.

When done you may point your browser to http://localhost:13000/ - Hygieia listens on TCP3000 and is forwarded to TCP13000 in the Vagrantfile.

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
