#!/usr/bin/env python

import boto3
import json

client = boto3.client('ec2')

filters = [{  
  'Name': 'tag:Group',
  'Values': ['gitops-asg']
}]

#response = client.describe_instances(Filters=filters)
response = client.describe_instances()

hosts = []

for r in response['Reservations']:
  for i in r['Instances']:
    try:
      hosts.append(i['PublicIpAddress'])
    except:
      pass
#    hosts.append(i['PublicIpAddress'])
# ['InstanceId'])
#    for tag in i['Tags']:
#      print (tag)
#    print (i['InstanceId'])
#    print (i['PrivateIpAddress'])

result = {
  "tag_Group_gitops_asg": {
    "hosts": hosts
  }
}

print (json.dumps(result))
