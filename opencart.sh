#!/bin/bash

yum install -y httpd nano git
systemctl enable httpd
yum install -y yum-utils
yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php74
yum install php php-{mysqlnd,fpm,zip,mbstring,tokenizer,json,gd,xml,bcmath} -y
systemctl restart httpd
php -v
wget https://cloudservice-v3.obs.cn-east-3.myhuaweicloud.com/opencart.zip
unzip opencart.zip
cp upload/* /var/www/html/ -rf
chmod -R 777 /var/www/html/
cd /var/www/html/
pwd
ll | grep config.php
nano config.php
cd admin/
pwd
ll | grep config.php
