#!/bin/bash

PROJECT_NAME="$1"

# Stop on error
set -e

source .env

# Check if DOMAIN_NAME is set
if [ -z "$DOMAIN_NAME" ]; then
    echo "Error: DOMAIN_NAME not set in .env file."
    exit 1
fi

# Check if both variables are unset or set to empty strings
if [[ -z "$SSL_CERTIFICATE_PATH" ]] || [[ -z "$SSL_CERTIFICATE_KEY_PATH" ]]; then
    # Command to generate the self-signed certificate inside the container
    docker exec $NGINX_CONTAINER_NAME openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "/etc/nginx/ssl/signed.key" -out "/etc/nginx/ssl/signed.crt" -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourUnit/CN=$DOMAIN_NAME" || { echo "Failed to generate Self-signed cerificate for $DOMAON_NAME"; exit 1; }
else
    docker cp $CCL_CERTIFICATE_PATH $NGINX_CONTAINER_NAME:/etc/nginx/ssl/signed.crt || { echo "Failed to copy provided ssl certificate"; exit 1; }
    docker cp $CCL_CERTIFICATE_KEY_PATH $NGINX_CONTAINER_NAME:/etc/nginx/ssl/signed.key || { echo "Failed to copy provided ssl certificate key"; exit 1; }
fi

# Remove default nginx config file
docker exec $NGINX_CONTAINER_NAME rm -f /etc/nginx/conf.d/default.conf || { echo "Failed to remove default Nginx configuration"; exit 1; }

# Create a nginx config file in host machine
rm -f nginx-service/nginx.conf.temp
sed "s/DOMAIN_PLACEHOLDER/$DOMAIN_NAME/g" nginx-service/nginx.conf > nginx-service/nginx.conf.temp

# Replace the domain placeholder in the Nginx configuration file
docker cp nginx-service/nginx.conf.temp $NGINX_CONTAINER_NAME:/etc/nginx/conf.d/nginx.conf || { echo "Failed to copy generated nginx config"; exit 1; }

rm -f nginx-service/nginx.conf.temp

# Restart the container for changes to take effect
docker-compose -p $PROJECT_NAME restart $NGINX_SERIVE_NAME || { echo "Failed to restart Nginx"; exit 1; }

# Check if nginx is accessible
docker exec $NGINX_CONTAINER_NAME ./wait-for-it.sh localhost:$NGINX_PORT --timeout=60 --strict -- echo "NGINX is up"