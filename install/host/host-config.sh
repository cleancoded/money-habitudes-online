#!/bin/bash

yum -y update;
yum -y install epel-release;
yum -y install firewalld httpd docker docker-compose python-certbot-apache;

systemctl enable firewalld;
systemctl start firewalld;
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent

systemctl enable docker;
systemctl start docker;
