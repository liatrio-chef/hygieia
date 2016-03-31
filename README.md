hygieia-liatrio Cookbook
========================
A cookbook to compile hygieia with github, stash, jenkins, udeploy, and sonar collectors on CentOS 7.

Supported Platforms
-------------------

CentOS 7

Requirements
------------
Ensure the ChefDK is installed from https://downloads.chef.io/chef-dk/

Ensure the vagrant-berkshelf plugin is installed: `vagrant plugin install vagrant-berkshelf`

Usage
-----
`vagrant up` will install mongodb, create a mongo db with a user, build hygieia, and start on boot. May need to ssh to the VM and `cd ~/Hygieia; mvn clean install` multiple times due to network issues pulling down artifacts, also then restart which collector it failed on etc `sudo systemctl restart hygieia-ui`.

License and Authors
-------------------
Authors: Drew Holt <drew@liatrio.com>
