# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "liatrio/centos7chefjava"

  config.vm.network "forwarded_port", guest: 80, host: 1080
  config.vm.network "forwarded_port", guest: 443, host: 1443
  config.vm.network "forwarded_port", guest: 3000, host: 13000
  config.vm.network "forwarded_port", guest: 8080, host: 18088

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--memory", "3072"]
    #v.customize ["modifyvm", :id, "--name", "hygieia"]
  end

  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "hygieia-liatrio"
    chef.add_recipe "hygieia-liatrio::apache2"
    chef.json = {
      "java" => {
        "jdk_version" => "8"
      },
      "hygieia_liatrio" => {
        "dbname" => "dashboard",
        "dbhost" => "127.0.0.1",
        "dbport" => 27017,
        "dbusername" => "db",
        "dbpassword" => "dbpass"
      }
    }
  end

  config.vm.provision "shell", inline: "firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp --add-port=3000/tcp --add-port=8080/tcp && firewall-cmd --reload"

end
