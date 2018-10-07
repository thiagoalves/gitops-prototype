#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR/tests
virtualenv env > /dev/null
source env/bin/activate > /dev/null
pip install -r requirements.txt > /dev/null
export ANSIBLE_REMOTE_USER=ubuntu
export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
py.test --connection=ansible --ansible-inventory ../ansible/ec2.py --hosts='ansible://tag_Group_gitops_asg' ${1:-*}.py
cd ..
