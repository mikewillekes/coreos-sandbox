$new_discovery_url='https://discovery.etcd.io/new'

# To automatically replace the discovery token on 'vagrant up', uncomment
# the lines below:
#
if File.exists?('user-data') && ARGV[0].eql?('up')
 require 'open-uri'
 require 'yaml'

 token = open($new_discovery_url).read

 data = YAML.load(IO.readlines('user-data')[1..-1].join)
 data['coreos']['etcd']['discovery'] = token

 yaml = YAML.dump(data)
 File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end

#
# coreos-vagrant is configured through a series of configuration
# options (global ruby variables) which are detailed below. To modify
# these options, first copy this file to "config.rb". Then simply
# uncomment the necessary lines, leaving the $, and replace everything
# after the equals sign..

# Size of the CoreOS cluster created by Vagrant
$num_instances=3

# Change basename of the VM
# The default value is "core", which results in VMs named starting with
# "core-01" through to "core-${num_instances}".
$instance_name_prefix="core"

# Official CoreOS channel from which updates should be downloaded
$update_channel='beta'

# Customize CoreOS VMs
#$vm_memory = 1024
#$vm_cpus = 1
