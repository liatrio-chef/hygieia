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

License and Authors
-------------------
Authors: Drew Holt <drew@liatrio.com>
