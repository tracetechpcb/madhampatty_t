#!/bin/bash

# Stop on error
set -e

export MYSQL_PASSWORD='tracetech'
echo "MariaDB root password: $MYSQL_PASSWORD"

# Store the output in a log
exec > >(tee /var/log/entrypoint.log) 2>&1

# Execute additional scripts
echo "Starting Default MariaDB Init Scripts"
../mariadb_default_init.sh $MYSQL_PASSWORD

echo "Starting Custom MariaDB Init Scripts"
../mariadb_custom_init.sh $MYSQL_PASSWORD

# Then start your application
exec "$@"
