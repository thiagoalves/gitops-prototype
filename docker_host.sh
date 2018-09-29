#!/bin/bash

cd terraform
terraform init
terraform apply -auto-approve
cd ..

cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook -i custom_ec2.py -b -e host=tag_Group_gitops_asg docker_host.yml
cd ..

./test.sh docker_host
