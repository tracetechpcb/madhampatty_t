#!/bin/bash

# Stop on error
set -e

# Demo License Key with 10 users and expiry on 01-01-2100
LICENSE_KEY="ewogInVzZXJzIjogMTAsCiAiZXhwaXJ5X29uIjogIjAxLTAxLTIxMDAiCn0="
#LICENSE_KEY="ewogInVzZXJzIjogMTAsCiAiZXhwaXJ5X29uIjogIjAxLTAxLTIxMDAiCn0=111111111111"

# Do not changes these values. These values are also used in docker-compose.yml
# If you change this, then you will have to make the same changes in docker-compose.yml
DB_ROOT_USER="root"
DB_ROOT_PASSWORD="tracetech"
DB_NAME="tracetech_db"
DB_CONATINER_NAME="mariadb"

# Wait till MariaDb is up
../wait-for-it.sh mariadb:3306 --timeout=60 --strict -- echo "Database is up"

echo "Starting Default MariaDB Init Scripts"
../mariadb_default_init.sh $DB_CONATINER_NAME $DB_ROOT_USER $DB_ROOT_PASSWORD $DB_NAME

echo "Starting Custom MariaDB Init Scripts"
../mariadb_custom_init.sh $DB_CONATINER_NAME $DB_ROOT_USER $DB_ROOT_PASSWORD $DB_NAME $LICENSE_KEY

# Then start your application
exec "$@"
