# -*- mode: ruby -*-
# vi: set ft=ruby :
# vi: set ft=ruby :
# vi: set ft=ruby :

## Set this to true if you want to run the VM in a window instead of in headless mode
GUI = false 

## Change this to "public_network" if you want a bridged interface to your local network
NETWORK = "private_network"

## The host name to use for the vagrant box
HOSTNAME = "drupal.local"

## Which base box to use
BOX = "ubuntu/trusty64"

## Number of CPUs to give to the VM
CPUS = "2"

## How much memory to give the VM, in MB
MEMORY = "4096"

## Method used for synced folders. The default (empty) is to use the VM Provider's
## file sharing method. Other valid values include: nfs, smb, or rsync. See
## http://docs.vagrantup.com/v2/synced-folders/index.html for more information.
SYNC = ""

################################################################################

# Require vagrant 1.6.2 or higher
Vagrant.require_version ">= 1.6.2"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ## Ubuntu 14.04 LTS (trusty) is the target Ubuntu version for the rules in this
  ## repository. Everything should work on this VM.
  config.vm.define "trusty", primary: true do |vbox|
    vbox.vm.hostname = HOSTNAME
    vbox.vm.box = BOX
  end

  # Provider-specific VM settings
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", MEMORY]
    vb.customize ["modifyvm", :id, "--cpus", CPUS]
  end

  ## Virtual Machine network configuration.

  # Network settings
  config.vm.network NETWORK, type: "dhcp"

  # Run the VM in a window if GUI is true
  config.vm.provider "virtualbox" do |v|
    v.gui = GUI
  end

  ## Synced folders
  config.vm.synced_folder ".", "/var/www/drupal.local", type: SYNC
  config.vm.synced_folder "~/", "/vhome"

  # ~/.gitconfig
  config.vm.provision "shell",
    inline: "cp -v /vhome/.gitconfig /home/vagrant/.gitconfig || /bin/true",
    run: "always"

  # ~/.ssh
  config.vm.provision "shell",
    inline: "rsync -av --delete --exclude=authorized_keys /vhome/.ssh/ /home/vagrant/.ssh/ || /bin/true",
    run: "always"

  # VM Provisioning

  # Fix eth1 routing that vagrant adds. It just slows down boot time (A LOT!)
  config.vm.provision "shell",
    inline: "sed -i '/post-up route del default dev/d' /etc/network/interfaces",
    run: "always"

  # Run aptitude update before other provisioning takes place
  config.vm.provision "shell", inline: "aptitude update"

  # Local Puppet provisioner
  # Here we are telling vagrant to load the "vagrant.pp" manifest file, which describes how to configure our VM
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = ".puppet/modules"
    puppet.manifests_path = ".puppet"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = "--verbose --show_diff --hiera_config /vagrant/.puppet/hiera.yaml --debug"
  end
  # Show the VM IP address after a successful provision
  config.vm.provision "shell",
    inline: "echo IP\ Address:\ `ip addr show dev eth1 scope global 2>&1 | grep inet | awk '{print $2}' | awk -F / '{print $1}'`",
    run: "always"

end
