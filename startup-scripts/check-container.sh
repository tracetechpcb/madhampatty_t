#!/bin/bash

PROJECT_NAME="$1"

# Stop on error
set -e

source .env

# List of required containers
required_containers=("$DB_CONTAINER_NAME" "$NGINX_CONTAINER_NAME" "$GUNICORN_CONTAINER_NAME" "$REACT_CONTAINER_NAME")

# Function to check if a container is up
is_container_up() {
    local container_name=$1
    local max_attempts=5  # Maximum number of attempts
    local attempt=1
    local delay=10  # Delay in seconds between attempts

    echo "Checking if $container_name is up..."
    while [ $attempt -le $max_attempts ]; do
        # Check if the container is running
        docker-compose -p $PROJECT_NAME ps | grep "$container_name" | grep "Up" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$container_name is up."
            return 0
        else
            if [ $attempt -lt $max_attempts ]; then
                echo "$container_name is not up yet. Retrying in $delay seconds..."
                sleep $delay
            else
                echo "Failed to start $container_name after $max_attempts attempts."
            fi
        fi
        attempt=$((attempt + 1))
    done
    return 1
}


# Check all required containers
for container in "${required_containers[@]}"; do
    echo
    echo "*************"
    if ! is_container_up $container; then
        echo "Error: Required container '$container' is not up."
        exit 1
    fi
done

echo "All required containers are up."