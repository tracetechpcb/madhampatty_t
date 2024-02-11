#!/bin/bash

DB_ROOT_USER="$1"
DB_ROOT_PASSWORD="$2"
DB_NAME="$3"
LICENSE_KEY="$4"


DEFAULT_USERNAME="admin@tracetech.com"
DEFAULT_PASSWORD="admin123A!!"

# Check if LICENSE_KEY is empty
if [ -z "$LICENSE_KEY" ]; then
    echo "License key is empty. Provide license key."
    exit 1
fi

# SQL command to create database
CREATE_DB_CMD="CREATE DATABASE IF NOT EXISTS $DB_NAME;"
echo $CREATE_DB_CMD
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD  -e "$CREATE_DB_CMD"


# Let Django create/alter tables based on models
python manage.py makemigrations
python manage.py migrate

# This command gathers static files from your apps and any directories specified in STATICFILES_DIRS into the STATIC_ROOT directory.
rm -rf staticfiles #remove the folder before collecting again
python manage.py collectstatic


# SQL command to create license table
#CREATE_LINCESE_TABLE_CMD="CREATE TABLE IF NOT EXISTS license (
#    licensekey VARCHAR(255),
#    status VARCHAR(255)
#);"
#echo $CREATE_TABLE_CMD
#mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$CREATE_LINCESE_TABLE_CMD"

# SQL command to delete all entries from the license table
DELETE_LICENSE_CMD="DELETE FROM license;"
echo $DELETE_LICENSE_CMD
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$DELETE_LICENSE_CMD"

# SQL command to insert a licensekey into the license table
INSERT_LICENSE_CMD="INSERT INTO license (licensekey, status)
VALUES ('$LICENSE_KEY', 'active')
ON DUPLICATE KEY UPDATE licensekey = licensekey;"
echo $INSERT_LICENSE_CMD
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$INSERT_LICENSE_CMD"




# SQL command to create user_creds table
#CREATE_USER_CREDS_TABLE="CREATE TABLE IF NOT EXISTS user_creds (
#    username VARCHAR(255) NOT NULL,
#    password VARCHAR(255) NOT NULL,
#    reset BOOLEAN NOT NULL,
#    PRIMARY KEY (username)
#);"
#echo $CREATE_USER_CREDS_TABLE
#mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$CREATE_USER_CREDS_TABLE"

# SQL command to create default user
INSERT_DEFAULT_USER_CMD="INSERT INTO auth_user (username, password, last_login, is_superuser, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES ('$DEFAULT_USERNAME', '$DEFAULT_PASSWORD', NULL, 1, 'Admin', 'Tracetech', 'admin@tracetech.com', 0, 1, NOW())
ON DUPLICATE KEY UPDATE username=VALUES(username);"
echo $INSERT_DEFAULT_USER_CMD
mysql -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$INSERT_DEFAULT_USER_CMD"