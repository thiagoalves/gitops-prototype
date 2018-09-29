#!/bin/bash -xe

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR/tests
virtualenv env
source env/bin/activate
pip install -r requirements.txt
export ANSIBLE_REMOTE_USER=ubuntu
export ANSIBLE_SSH_ARGS="-C -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
py.test --connection=ansible --ansible-inventory ../ansible/custom_ec2.py --hosts='ansible://tag_Group_gitops_asg' ${1:-*}.py
cd ..
