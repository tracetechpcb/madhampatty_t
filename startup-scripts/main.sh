#!/bin/bash

PROJECT_NAME="$1"

# Stop on error
set -e

source .env

# Initially check if all the containers are up and running
./startup-scripts/check-container.sh $PROJECT_NAME

#List of other startup scripts
scripts=("startup-scripts/mariadb-poststartup.sh" "startup-scripts/nginx-poststartup.sh" "startup-scripts/react-poststartup.sh")

# Loop through the array and execute each script
for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        echo
        echo "*****************************"
        echo "Executing $script....."
        ./"$script" $PROJECT_NAME
    else
        echo "Error: Script $script not found or not executable."
    fi
done
