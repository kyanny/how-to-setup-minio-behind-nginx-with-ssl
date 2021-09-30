# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provision "shell", path: "00apt.sh"
  config.vm.provision "shell", path: "01nginx.sh"
  config.vm.provision "shell", path: "02cert.sh"
  config.vm.provision "shell", path: "03nginx.sh"
  config.vm.provision "shell", path: "04minio.sh"
end
