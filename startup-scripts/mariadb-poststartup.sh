#!/bin/bash

PROJECT_NAME="$1"

# Stop on error
set -e

source .env


#Delete any users from mysql.user table with an empty username
CMD_DELETE_EMPTY_USERS="DELETE FROM mysql.user WHERE User='';"
echo "Deleting empty users..."
docker exec $DB_CONTAINER_NAME mysql -u $DB_ROOT_USERNAME --password=$DB_ROOT_PASSWORD -e "$CMD_DELETE_EMPTY_USERS"


# Drop the test database if it exists
CMD_DROP_TEST_DB="DROP DATABASE IF EXISTS test;"
echo "Dropping test database..."
docker exec $DB_CONTAINER_NAME mysql -u $DB_ROOT_USERNAME --password=$DB_ROOT_PASSWORD -e "$CMD_DROP_TEST_DB"


# Delete any privileges on the test database or databases starting with test_
CMD_DELETE_TEST_DB_PRIVILEGES="DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
echo "Deleting privileges on test databases..."
docker exec $DB_CONTAINER_NAME  mysql -u $DB_ROOT_USERNAME --password=$DB_ROOT_PASSWORD -e "$CMD_DELETE_TEST_DB_PRIVILEGES"


# Flush privileges to ensure all changes take effect immediately
CMD_FLUSH_PRIVILEGES="FLUSH PRIVILEGES;"
echo "Flushing privileges..."
docker exec $DB_CONTAINER_NAME mysql -u $DB_ROOT_USERNAME --password=$DB_ROOT_PASSWORD -e "$CMD_FLUSH_PRIVILEGES"
