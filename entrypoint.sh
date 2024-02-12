#!/bin/bash

# Stop on error
set -e

# Wait till MariaDb is up
echo "../wait-for-it.sh $DB_CONTAINER_NAME:$DB_PORT --timeout=60 --strict -- echo \"Database is up\""
../wait-for-it.sh $DB_CONTAINER_NAME:$DB_PORT --timeout=60 --strict -- echo "Database is up"

echo "Starting Default MariaDB Init Scripts"
../mariadb_default_init.sh

echo "Starting Custom MariaDB Init Scripts"
../mariadb_custom_init.sh

# Then start your application
exec "$@"
