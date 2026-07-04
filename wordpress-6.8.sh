yum update -y
yum install httpd nano yum-utils -y
yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php82
yum install php php-cli php-fpm php-mysqlnd php-gd php-opcache php-zip php-mbstring php-curl php-xml -y
php -v
systemctl start php-fpm
systemctl enable php-fpm

wget https://wordpress.org/wordpress-6.8.zip
unzip wordpress-6.8.zip
ls
cp -rf wordpress /var/www/html/
cd /var/www/html/wordpress/
ls
cp wp-config-sample.php wp-config.php

chmod -R 777 wp-content/
systemctl start httpd
systemctl enable httpd