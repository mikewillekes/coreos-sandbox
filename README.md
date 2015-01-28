# CoreOS Sandbox

A simple sandbox environment to get started locally with [Docker](https://www.docker.com/) and [CoreOS](https://coreos.com/)
using Vagrant (and VirtualBox).

### Vagrantfile

Based on the [Minimal CoreOS VargantFile](https://github.com/coreos/coreos-vagrant/) this configuration adds a development
machine for building Docker containers and a local insecure Docker registry for pushing from the development machine and 
pulling from the CoreOS cluster

 - Multi-machine configuration
   - Private network `172.18.8.0/24`
   - 1 development machine
     - Ubuntu (`ubuntu/trusty64`)
     - Docker 
     - Insecure local Docker registry
   - N (default 3) CoreOS machines

## Prerequisites 

 - [VirtualBox](https://www.virtualbox.org/)
 - [Vagrant](https://www.vagrantup.com/)

## Deployment

1. Clone this repo

		git clone https://github.com/mikewillekes/coreos-sandbox.git
		cd coreos-sandbox

2. Create `user-data` from sample file

		cp user-data.sample user-data

3. Launch 

		vagrant up


## Local Docker Registry

The local insecure Docker registry is running at `172.18.8.100:5000`, registry is store in 
the host filesystem at `./registry`
> During provisioning, the development machine will build a simple Tomcat7 Docker container
and push to the local registry. Each of the CodeOS machines will pull that same image to verify
the registry is working

To work with this local registry, preface your build tags with `172.18.8.100:5000/`

	sudo docker build -t 172.18.8.100:5000/myusername/myamazingcontainer .
	sudo docker push 172.18.8.100:5000/myusername/myamazingcontainer

