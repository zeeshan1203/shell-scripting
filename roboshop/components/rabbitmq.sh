#!/bin/bash

source components/common.sh
rm -f /tmp/roboshop.log
set-hostname rabbitmq

HEAD "Install ERLANG\t\t\t"
yum list installed | grep erlang &>>/tmp/roboshop.log
if [ $? -eq 0 ]; then
  echo "Erlang is already Installed" &>>/tmp/roboshop.log
  STAT $?
else
  yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/roboshop.log
  STAT $?
fi

HEAD "Setup RabbitMQ Yum Repos\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/roboshop.log
STAT $?

HEAD "Install RabbitMQ Server\t"
yum install rabbitmq-server -y &>>/tmp/roboshop.log
STAT $?

HEAD "Start RabbitMQ Server\t\t"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log &&  systemctl restart rabbitmq-server &>>/tmp/roboshop.log
STAT $?

HEAD "Create Application User in RabbitMQ"
rabbitmqctl list_users | grep roboshop &>>/tmp/roboshop.log
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log
fi
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/roboshop.log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
STAT $?