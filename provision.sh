#!/usr/bin/env bash

# Get prerequisites
sudo apt-get -y update
sudo apt-get install -y curl wget git build-essential openjdk-7-jdk maven python-pip python-dev tofrodos

# Upgrade Python package manager
sudo pip install --upgrade pip 
sudo pip install --upgrade virtualenv

# Get Apacke Kafka
export KAFKA=kafka_2.9.2-0.8.1.1
cd /home/vagrant
if [ ! -d "$KAFKA" ]; then
  wget --quiet http://mirror.csclub.uwaterloo.ca/apache/kafka/0.8.1.1/$KAFKA.tgz
  tar -xzf $KAFKA.tgz
  rm $KAFKA.tgz
  ln -s $KAFKA kafka
fi 

# Get insecure vagrant keys so Dev box can SSH into rest of cluster
wget --quiet --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant -O /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa
wget --quiet --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/id_rsa.pub
chmod 600 /home/vagrant/.ssh/id_rsa.pub

#
# Install Docker
#

# Helper script to install on Ubuntu
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# Custom config to support insecure repository (other than localhost)
sudo service docker stop
sudo cp -f /vagrant/docker /etc/default/docker && sudo fromdos /etc/default/docker
sudo service docker start
sleep 5

# Launch insecure repository. Poll with Netcat until port 5000 responds
sudo docker run -d -p 5000:5000 -v /tmp/registry:/tmp/registry registry

# Lame to hardcode a sleep, but we need to make sure the registry container is up
# TODO: Poll until 'curl http://172.18.8.100:5000/v1/_ping' returns a valid JSON response
sleep 5

#NGINX: args: "-p 8080:80 -p 8443:443 -v /vagrant/nginx.conf:/etc/nginx/nginx.conf:ro -v /vagrant/www:/usr/share/nginx/html:ro"

# Build sandbox (Tomcat 7) container to verify everything's working
docker build -t 172.18.8.100:5000/sandbox/tomcat:7 /vagrant/samples/tomcat
docker push 172.18.8.100:5000/sandbox/tomcat:7
docker pull 172.18.8.100:5000/sandbox/tomcat:7