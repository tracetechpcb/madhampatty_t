# Use the official Nginx image as the base image
FROM nginx:alpine

# Install openssl for generating self-signed certificate and bash
RUN apk add --no-cache openssl bash

# Create the directory for SSL certificates and copy SSL certs
RUN mkdir -p /etc/nginx/ssl/
COPY ./nginx-service/signed.crt /etc/nginx/ssl/signed.crt
COPY ./nginx-service/signed.key /etc/nginx/ssl/signed.key

# Remove the default Nginx configuration file and copy custom config to nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx-service/nginx.conf /etc/nginx/conf.d/

# Expose port 80 to the Docker host
EXPOSE 80 443
