#!/bin/bash

disable-auto-shutdown

HEAD() {
  echo -n -e "\e[1m $1 \e[0m \t\t..."
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32m done\e[0m"
  else
    echo -e "\e[1;31m fail\e[0m"
    echo -e "\e[1;33m Check the log for more detail .... Log-File : /tmp/roboshop.log\e[0m"
    exit 1
  fi
}

APP_USER_ADD() {
  HEAD "Add Roboshop App User\t\t"
  id roboshop &>>/tmp/roboshop.log
  if [ $? -eq 0 ]; then
    echo User is already there,So Skipping the User creation &>>/tmp/roboshop.log
    STAT $?
  else
    useradd roboshop &>>/tmp/roboshop.log
    STAT $?
  fi
}

SETUP_SYSTEMD() {
  HEAD "Setup SystemD Service\t"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/$1/systemd.service  && mv /home/roboshop/$1/systemd.service /etc/systemd/system/$1.service
  STAT $?

  HEAD "Start $1 Service\t\t"
  systemctl daemon-reload && systemctl enable $1 &>>/tmp/roboshop.log && systemctl restart $1 &>>/tmp/roboshop.log
  STAT $?
}

DOWNLOAD_FROM_GITHUB() {
  HEAD "Download App From GitHub\t"
  curl -s -L -o /tmp/$1.zip "https://github.com/roboshop-devops-project/$1/archive/main.zip" &>>/tmp/roboshop.log
  STAT $?

  HEAD "Extract the Downloaded Archive\t"
  cd /home/roboshop && rm -rf $1 && unzip /tmp/$1.zip &>>/tmp/roboshop.log && mv $1-main $1
  STAT $?
}
NODEJS() {
  HEAD "Install NodeJS\t\t\t"
  yum install nodejs make gcc-c++ -y &>>/tmp/roboshop.log
  STAT $?

  APP_USER_ADD
  DOWNLOAD_FROM_GITHUB

  HEAD "Install NodeJS Dependencies\t"
  cd /home/roboshop/$1 && npm install --unsafe-perm &>>/tmp/roboshop.log
  STAT $?

  HEAD "Fix Permissions to App Content"
  chown roboshop:roboshop /home/roboshop -R
  STAT $?

  SETUP_SYSTEMD "$1"

}

MAVEN() {
  HEAD "Install Maven"
  yum install maven -y &>>/tmp/roboshop.log
  STAT $?

  APP_USER_ADD
  DOWNLOAD_FROM_GITHUB

  HEAD "Make Application Package"
  cd /home/roboshop/$1 && mvn clean package &>>/tmp/roboshop.log && mv target/$1-1.0.jar $1.jar &>>/tmp/roboshop.log
  STAT $?

  HEAD "Fix Permissions to App Content"
  chown roboshop:roboshop /home/roboshop -R
  STAT $?

  SETUP_SYSTEMD "$1"

}