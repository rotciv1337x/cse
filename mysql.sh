#!/bin/bash

set -euo pipefail

MYSQL_BUNDLE="MySQL-5.6.45-1.el6.x86_64.rpm-bundle.tar"
MYSQL_URL="https://cloudservice-v3.obs.cn-east-3.myhuaweicloud.com/${MYSQL_BUNDLE}"
INSTALL_DIR="/opt/mysql_install"
MYSQL_PASSWORD="Huawei@1234!"

echo "=== Downloading MySQL bundle ==="
cd /opt
wget -O "${MYSQL_BUNDLE}" "${MYSQL_URL}"

echo "=== Extracting bundle ==="
mkdir -p "${INSTALL_DIR}"
tar -xvf "${MYSQL_BUNDLE}" -C "${INSTALL_DIR}"

cd "${INSTALL_DIR}"

echo "=== Removing MariaDB ==="
yum -y remove 'mariadb*' || true

echo "=== Installing MySQL RPMs ==="
yum -y install ./*.rpm

echo "=== Configuring MySQL ==="
cat <<EOF >> /etc/my.cnf

[mysqld]
join_buffer_size = 128M
sort_buffer_size = 2M
read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

# Disabling symbolic-links is recommended to prevent assorted security risks
lower_case_table_names = 1
innodb_strict_mode = 1
sql_mode =
symbolic-links = 0
character_set_server = utf8

log-bin = mysql-bin
binlog_format = row
server-id = 2
expire_logs_days = 10
slave_skip_errors = 1062
innodb_strict_mode = 0

[mysqld_safe]
log-error = /var/log/mysqld.log
pid-file = /var/run/mysqld/mysqld.pid
EOF

echo "=== Current MySQL configuration ==="
cat /etc/my.cnf

echo "=== Starting MySQL ==="
systemctl start mysql
systemctl status mysql --no-pager

echo "=== Installing expect ==="
yum install -y expect

echo "=== Setting MySQL root password ==="

TEMP_PASS=$(awk -F"[ :]+" 'NR==1{print $NF}' /root/.mysql_secret)

expect <<EOF
spawn /usr/bin/mysql -h127.0.0.1 -uroot -p$TEMP_PASS
expect "mysql>"
send "SET PASSWORD FOR root@localhost=PASSWORD('${MYSQL_PASSWORD}');\r"
expect "mysql>"
send "flush privileges;\r"
expect "mysql>"
send "quit;\r"
expect eof
EOF

echo "=== Enabling remote root access ==="

mysql -uroot -p"${MYSQL_PASSWORD}" <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo
echo "=========================================="
echo "MySQL installation completed successfully."
echo "Root password: ${MYSQL_PASSWORD}"
echo
echo "Login with:"
echo "mysql -u root -p"
echo "=========================================="