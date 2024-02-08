#!/bin/bash

MYSQL_PASSWORD="$1"

# Start MariaDB service
service mariadb start

# Wait for MariaDB to be ready (optional sleep to ensure MariaDB is fully up)
sleep 10

# Perform the necessary database initializations
CMD="ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"

CMD="DELETE FROM mysql.user WHERE User='';"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"

CMD="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"

CMD="DROP DATABASE IF EXISTS test;"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"

CMD="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"

CMD="FLUSH PRIVILEGES;"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"
