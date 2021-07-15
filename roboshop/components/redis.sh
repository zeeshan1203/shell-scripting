#!/bin/bash

source components/common.sh
rm -f /tmp/roboshop.log
set-hostname redis

HEAD "Setup Redis Repos\t\t\t"
yum install epel-release yum-utils yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/roboshop.log && yum-config-manager --enable remi &>>/tmp/roboshop.log
STAT $?

HEAD "Install Redis\t\t\t"
yum install redis -y &>>/tmp/roboshop.log
STAT $?

HEAD "Update Listen Address in Config File"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
STAT $?

HEAD "Start Redis Service\t\t\t"
systemctl enable redis &>>/tmp/roboshop.log && systemctl restart redis &>>/tmp/roboshop.log
STAT $?
