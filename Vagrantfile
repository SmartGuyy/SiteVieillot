# -*- mode: ruby -*-
# vi: set ft=ruby :
 
Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.define "gitlabserver" do |gitlabserver|
    gitlabserver.vm.box = "bento/centos-8"
    gitlabserver.vm.provider "virtualbox" do |vb|
      vb.gui = "true"
      vb.memory = "6144"
      vb.cpus = "4"
end
    gitlabserver.disksize.size = '100GB' 
    gitlabserver.vm.hostname = "gitlabserver"
    gitlabserver.vm.network "forwarded_port", guest: 8000, host: 8020
    gitlabserver.vm.network "private_network", ip: "192.168.34.10"
    gitlabserver.vm.provision "shell", path: "scriptserver.sh"
    gitlabserver.vm.synced_folder ".", "/vagrant", type: "nfs"
  end
 
  config.vm.define "recette" do |recette|
    recette.vm.box = "debian/buster64"
    recette.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
end
    recette.vm.hostname = "recette"
    recette.vm.network "forwarded_port", guest: 8000, host: 8010
    recette.vm.network "private_network", ip: "192.168.34.20" 
    recette.vm.synced_folder ".", "/vagrant", type: "nfs"
    recette.vm.provision "shell", path: "scriptother.sh"
  end

  config.vm.define "production" do |production|
    production.vm.box = "debian/buster64"
    production.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
end
    production.vm.hostname = "production"
    production.vm.network "forwarded_port", guest: 8000, host: 8080
    production.vm.network "private_network", ip: "192.168.34.30" 
    production.vm.synced_folder ".", "/vagrant", type: "nfs"
    production.vm.provision "shell", path: "scriptother.sh"
  end
end
