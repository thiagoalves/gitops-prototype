#!/bin/bash

sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
sudo mkdir /usr/src/central-ansible
sudo chown ubuntu.ubuntu /usr/src/central-ansible
