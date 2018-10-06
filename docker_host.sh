#!/bin/bash

[ -z $1 ] && echo "Missing env parameters [prod / staging]" && exit 1

if [ $1 == "staging" ]; then
	export AWS_REGION=us-west-1
else
	export AWS_REGION=us-east-2
fi
export TF_VAR_AWS_REGION=$AWS_REGION

rootdir=$(pwd)

cd terraform/$1
terraform init > /dev/null
terraform apply -auto-approve
cd $rootdir

cd ansible
ansible-galaxy install -r requirements.yaml
ansible-playbook -i custom_ec2.py -b -e host=tag_Group_gitops_asg docker_host.yaml
cd $rootdir

./test.sh docker_host
