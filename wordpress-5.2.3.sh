yum update -y
yum install httpd nano yum-utils -y
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum install -y --enablerepo=remi --enablerepo=remi-php72 php php-opcache php-devel php-mysqlnd php-gd php-redis
php -v
wget https://cloudservice-v3.obs.cn-east-3.myhuaweicloud.com/wordpress-5.2.3_en.zip 
unzip wordpress-5.2.3_en.zip 
cp -rf wordpress /var/www/html/ 
cd /var/www/html/wordpress/
ls
cp wp-config-sample.php wp-config.php
cd /var/www/html/wordpress 
echo -e "define(\"FS_METHOD\", \"direct\");\ndefine(\"FS_CHMOD_DIR\", 0777);\ndefine(\"FS_CHMOD_FILE\", 0777);" >> wp-config.php 
tail -n 5 wp-config.php 
chmod -R 777 wp-content/
systemctl start httpd
systemctl enable httpd