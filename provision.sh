#!/bin/bash

cd terraform
terraform init
terraform apply -auto-approve

cd ../ansible
ansible-galaxy install -r requirements.yml
ansible-playbook -i custom_ec2.py -b -e host=tag_Group_gitops_asg docker.yml

cd ../testinfra
virtualenv env
source env/bin/activate
pip install -r requirements.txt
ANSIBLE_REMOTE_USER=ubuntu py.test --connection=ansible --ansible-inventory ../ansible/custom_ec2.py --hosts='ansible://tag_Group_gitops_asg' --ssh-config=ssh_config *.py
