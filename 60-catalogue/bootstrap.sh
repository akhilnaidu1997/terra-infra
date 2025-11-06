#!/bin/bash

sudo dnf install ansible -y
component=$1
env=$2

REPO_URL=https://github.com/akhilnaidu1997/ansible-roboshop-roles-tf.git
REPO_DIR=/opt/ansible
LOG_PATH=/var/log/ansible.log
REPO_MAIN=ansible-roboshop-roles-tf

mkdir -p /opt/ansible
mkdir -p /var/log

touch /var/log/ansible.log

cd $REPO_DIR

if [ -d $REPO_MAIN ]; then
    cd $REPO_MAIN
    git pull
else
    git clone $REPO_URL
    cd $REPO_MAIN
fi

ansible-playbook -e component=$component -e env=$env main.yaml