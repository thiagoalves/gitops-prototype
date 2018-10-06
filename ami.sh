#!/bin/bash

cd packer

[ -z $1 ] && echo "Missing region parameter" && exit 1

subnet_id=$(aws ec2 describe-subnets --filters Name=defaultForAz,Values=true --filters Name=availabilityZone,Values=${1}a | jq -r '.Subnets[].SubnetId' | head -n1)
echo "Default subnet for region ${1}a: $subnet_id"

packer build -force -var region=$1 -var subnet_id=$subnet_id ami.json

cd ..
