#!/bin/bash

DB_ROOT_USER="$1"
DB_ROOT_PASSWORD="$2"
DB_NAME="$3"

# Start MariaDB service
service mariadb start

# Wait for MariaDB to be ready (optional sleep to ensure MariaDB is fully up)
sleep 10

# Alter the root user's password
CMD_ALTER_ROOT_PASS="ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"
echo "Altering root user password..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_ALTER_ROOT_PASS"

# Delete any users from mysql.user table with an empty username
CMD_DELETE_EMPTY_USERS="DELETE FROM mysql.user WHERE User='';"
echo "Deleting empty users..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_DELETE_EMPTY_USERS"

# Delete root users that are accessible from hosts other than localhost, 127.0.0.1, or ::1
CMD_DELETE_REMOTE_ROOT="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
echo "Deleting remote root users..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_DELETE_REMOTE_ROOT"

# Drop the test database if it exists
CMD_DROP_TEST_DB="DROP DATABASE IF EXISTS test;"
echo "Dropping test database..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_DROP_TEST_DB"

# Delete any privileges on the test database or databases starting with test_
CMD_DELETE_TEST_DB_PRIVILEGES="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
echo "Deleting privileges on test databases..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_DELETE_TEST_DB_PRIVILEGES"

# Flush privileges to ensure all changes take effect immediately
CMD_FLUSH_PRIVILEGES="FLUSH PRIVILEGES;"
echo "Flushing privileges..."
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD -e "$CMD_FLUSH_PRIVILEGES"