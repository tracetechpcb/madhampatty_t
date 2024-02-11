#!/bin/bash

DB_CONATINER_NAME="$1"
DB_ROOT_USER="$2"
DB_ROOT_PASSWORD="$3"
DB_NAME="$4"
LICENSE_KEY="$5"

DEFAULT_USERNAME="admin@tracetech.com"
DEFAULT_PASSWORD="admin123A!!"

# Check if LICENSE_KEY is empty
if [ -z "$LICENSE_KEY" ]; then
    echo "License key is empty. Provide license key."
    exit 1
fi


# Let Django create/alter tables based on models
python manage.py makemigrations
python manage.py migrate

# This command gathers static files from your apps and any directories specified in STATICFILES_DIRS into the STATIC_ROOT directory.
rm -rf staticfiles #remove the folder before collecting again
python manage.py collectstatic


# License table is created by Django Models
# SQL command to delete all entries from the license table
DELETE_LICENSE_CMD="DELETE FROM license;"
echo $DELETE_LICENSE_CMD
mysql -h $DB_CONATINER_NAME -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$DELETE_LICENSE_CMD"

# SQL command to insert a licensekey into the license table
INSERT_LICENSE_CMD="INSERT INTO license (licensekey, status)
VALUES ('$LICENSE_KEY', 'active')
ON DUPLICATE KEY UPDATE licensekey = licensekey;"
echo $INSERT_LICENSE_CMD
mysql -h $DB_CONATINER_NAME -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$INSERT_LICENSE_CMD"


# License table is created by default by Django
# SQL command to create default user
INSERT_DEFAULT_USER_CMD="INSERT INTO auth_user (username, password, last_login, is_superuser, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES ('$DEFAULT_USERNAME', '$DEFAULT_PASSWORD', NULL, 1, 'Admin', 'Tracetech', 'admin@tracetech.com', 0, 1, NOW())
ON DUPLICATE KEY UPDATE username=VALUES(username);"
echo $INSERT_DEFAULT_USER_CMD
mysql -h $DB_CONATINER_NAME -u $DB_ROOT_USER --password=$DB_ROOT_PASSWORD $DB_NAME -e "$INSERT_DEFAULT_USER_CMD"