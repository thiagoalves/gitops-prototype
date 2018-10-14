#!/bin/bash

cd /tmp
git clone https://github.com/thiagoalves/gitops-samples/
cd gitops-samples
root_dir=$(pwd)
for dir in $(find . -type d); do
  cd $dir;
  [ -f docker-compose.yml ] && docker-compose up -d;
  [ -f up.sh ] && ./up.sh;
  cd $root_dir;
done
