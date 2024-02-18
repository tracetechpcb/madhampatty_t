#!/bin/bash

# Stop on error
set -e

source .env

# Wildcard * will be intepreted different by docker deamon. So we execute the command by given it to the shell
docker exec $REACT_CONTAINER_NAME /bin/bash -c "cp -r build/* /usr/share/nginx/html" || { echo "Failed to copy build files to nginx static file location"; exit 1; }
