#!/bin/bash -xe

[ -z $1 ] && echo "Missing env parameters [prod / staging]" && exit 1

rootdir=$(pwd)

cd terraform/$1
terraform init > /dev/null
terraform apply -auto-approve
cd $rootdir

cd ansible
ansible-galaxy install -r requirements.yaml
#ansible-playbook -i ec2.py -b -e host=tag_Group_gitops_asg docker_host.yaml

cd $rootdir

./test.sh docker_host
