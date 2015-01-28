# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "user-data")
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Defaults for config options defined in CONFIG
$num_instances = 1
$instance_name_prefix = "core"
$update_channel = "alpha"
$enable_serial_logging = false
$share_home = false
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1

if File.exist?(CONFIG)
  require CONFIG
end

# Use old vb_xxx config variables when set
def vm_memory
  $vb_memory.nil? ? $vm_memory : $vb_memory
end

def vm_cpus
  $vb_cpus.nil? ? $vm_cpus : $vb_cpus
end

Vagrant.configure("2") do |config|

  #
  # Primary development machine
  #
  config.vm.define "dev", primary: true do |config|

    config.vm.box = "ubuntu/trusty64"
    config.vm.network :private_network, ip: "172.18.8.100"

    # Shell script provisioning
    config.vm.provision "shell", 
      privileged: false, 
      path: "provision.sh"

    # Config for development Docker registry
    config.vm.synced_folder "./registry", "/tmp/registry"

    # Config for Nginx
    config.vm.network "forwarded_port", guest: 8080, host: 8080
    config.vm.network "forwarded_port", guest: 8443, host: 8443

    config.vm.provider :virtualbox do |vb|
      vb.memory = 2048
      vb.cpus = 1
    end

  end

  #
  # Cluser of CoreOS machines as defined in config.rb
  #
  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|

      config.vm.box = "coreos-%s" % $update_channel
      config.vm.box_version = ">= 308.0.1"
      config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

      config.vm.provision :shell, 
        privileged: false,
        inline: 'rm -f /home/core/.bashrc && touch /home/core/.bashrc && echo "export TERM=ansi" >> /home/core/.bashrc'

      config.vm.provider :virtualbox do |v|
        # On VirtualBox, we don't have guest additions or a functional vboxsf
        # in CoreOS, so tell Vagrant that so it can be smarter.
        v.check_guest_additions = false
        v.functional_vboxsf     = false
      end

      # plugin conflict
      if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
      end

      config.vm.hostname = vm_name

      config.vm.provider :virtualbox do |vb|
        vb.memory = vm_memory
        vb.cpus = vm_cpus
      end

      ip = "172.18.8.#{i+100}"
      config.vm.network :private_network, ip: ip

      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end

    end
  end
end
