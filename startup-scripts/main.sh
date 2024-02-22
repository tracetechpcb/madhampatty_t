#!/bin/bash

PROJECT_NAME="$1"

# Stop on error
set -e

source .env

# Check if the required values are defined in .env file
if [[ -z "$DEFAULT_APPLICATION_USERNAME" ]] ||
    [[ -z "$DEFAULT_APPLICATION_PASSWORD" ]] ||
    [[ -z "$DEFAULT_APPLICATION_EMAIL" ]]
    [[ -z "$DOMAIN_NAME" ]] ||
    [[ -z "$LICENSE_KEY" ]] ; then
    echo "Mandatory fields are not populated in .env file"
    exit 1
fi

# Initially check if all the containers are up and running
./startup-scripts/check-container.sh $PROJECT_NAME

#List of other startup scripts
scripts=("startup-scripts/nginx-poststartup.sh" "startup-scripts/react-poststartup.sh")

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