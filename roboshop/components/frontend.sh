#!/bin/bash

source components/common.sh
rm -f /tmp/roboshop.log
set-hostname frontend

HEAD "Installing Nginx\t\t"
yum install nginx -y &>>/tmp/roboshop.log
STAT $?

HEAD "Download from GitHub\t\t"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/roboshop.log
STAT $?

HEAD "Delete old HTML DOCS\t\t"
rm -rf /usr/share/nginx/html*
STAT $?

HEAD "Extract Downloaded Content\t"
unzip -d /usr/share/nginx/html /tmp/frontend.zip &>>/tmp/roboshop.log
mv /usr/share/nginx/html/frontend-main/* /usr/share/nginx/html &>>/tmp/roboshop.log
mv /usr/share/nginx/html/static/* /usr/share/nginx/html &>>/tmp/roboshop.log
STAT $?


HEAD "Update Nginx Configuration\t"
mv /usr/share/nginx/html/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?

HEAD "Update Endpoints in Nginx Config"
for component in catalogue cart user shipping payment ; do
  sed -i -e "/${component}/ s/localhost/${component}.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
STAT $?

HEAD "Start Nginx\t\t\t"
systemctl restart nginx &>>/tmp/roboshop.log
systemctl enable nginx &>>/tmp/roboshop.log
STAT $?