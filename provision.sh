#!/usr/bin/env bash

# Get prerequisites
sudo apt-get -y update
sudo apt-get install -y curl wget git build-essential openjdk-7-jdk maven tomcat7 python-pip python-dev tofrodos

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