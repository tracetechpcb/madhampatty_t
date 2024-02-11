#!/bin/bash

# Stop on error
set -e

# Demo License Key with 10 users and expiry on 01-01-2100
LICENSE_KEY="ewogInVzZXJzIjogMTAsCiAiZXhwaXJ5X29uIjogIjAxLTAxLTIxMDAiCn0="
#LICENSE_KEY="ewogInVzZXJzIjogMTAsCiAiZXhwaXJ5X29uIjogIjAxLTAxLTIxMDAiCn0=111111111111"

DB_ROOT_USER="root"
DB_ROOT_PASSWORD="tracetech"
DB_NAME="tracetech"

# Execute additional scripts
echo "Starting Default MariaDB Init Scripts"
../mariadb_default_init.sh $DB_ROOT_USER $DB_ROOT_PASSWORD $DB_NAME

echo "Starting Custom MariaDB Init Scripts"
../mariadb_custom_init.sh $DB_ROOT_USER $DB_ROOT_PASSWORD $DB_NAME $LICENSE_KEY

# Then start your application
exec "$@"
