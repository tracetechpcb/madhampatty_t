#!/bin/bash

MYSQL_PASSWORD="$1"

CMD="CREATE DATABASE IF NOT EXISTS tracetech;"
echo $CMD
mysql -u root --password=$MYSQL_PASSWORD -e "$CMD"