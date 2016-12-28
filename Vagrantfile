# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'bento/centos-7.2'

  config.vm.network 'forwarded_port', guest: 80, host: 1080
  config.vm.network 'forwarded_port', guest: 443, host: 1443
  config.vm.network 'forwarded_port', guest: 3000, host: 13000
  config.vm.network 'forwarded_port', guest: 8080, host: 18080
  config.vm.network 'forwarded_port', guest: 27017, host: 37017

  # config.vm.synced_folder '~/.m2', '/home/vagrant/.m2',
  #                        owner: 'vagrant',
  #                        group: 'vagrant',
  #                        mount_options: ['dmode=775,fmode=664']

  config.vm.provider 'virtualbox' do |v|
    # fix for bento box issue https://github.com/chef/bento/issues/682
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.customize ['modifyvm', :id, '--cableconnected1', 'on']
    v.customize ['modifyvm', :id, '--cableconnected2', 'on']
    v.customize ['modifyvm', :id, '--cpus', 2]
    v.customize ['modifyvm', :id, '--memory', '3072']
    # v.customize ["modifyvm", :id, "--name", "hygieia"]
  end

  config.berkshelf.enabled = true

  config.vm.provision 'chef_solo' do |chef|
    chef.version = '12.16.42'

    chef.add_recipe 'hygieia-liatrio::mongodb'
    chef.add_recipe 'hygieia-liatrio::node'
    chef.add_recipe 'hygieia-liatrio'
    chef.add_recipe 'hygieia-liatrio::apache2'
    # chef.add_recipe "hygieia-liatrio::mongodb_sample_data" # add this recipe to add dummy data
    chef.json = {
      'java' => {
        'jdk_version' => '8'
      },
      'hygieia_liatrio' => {
        'user' => 'vagrant',
        'group' => 'vagrant',
        'home' => '/home/vagrant',
        'symlink' => '/vagrant/Hygieia/UI/dist',
        'dbname' => 'dashboard',
        'dbhost' => '127.0.0.1',
        'dbport' => 27017,
        'dbusername' => 'db',
        'dbpassword' => 'dbpass'
      }
    }
  end
end
