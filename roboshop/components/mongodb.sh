#!/bin/bash

source components/common.sh
rm -f /tmp/roboshop.log
sudo set-hostname frontend

HEAD "Setup MongoDB Yum repo file"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STAT $?

HEAD "Install MongoDB"
yum install -y mongodb-org &>>/tmp/roboshop.log


# systemctl enable mongod
# systemctl start mongod