# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # centos 6.5
  config.vm.box = "bradallenfisher/centos7"
  # ip address
  config.vm.network "private_network", ip: "192.168.7.7"
  # host name
  config.vm.hostname = "local.phpfpm.dev"

  # run script as root
  config.vm.provision "shell",
    path: "/vagrant/install/root.sh"
    
  # run script as vagrant user
  config.vm.provision "shell",
    path: "/vagrant/install/post-install.sh",
    privileged: FALSE

end
