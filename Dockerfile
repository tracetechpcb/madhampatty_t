# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install basic packages
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip \
    build-essential \
    curl \
    make \
    git \
    vim \
    wget \
    mariadb-server \
    mariadb-client \
    libmariadb-dev \
    libmariadb-dev-compat \
    pkg-config \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.10 as the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 \
    && update-alternatives --set python /usr/bin/python3.10

# Upgrade pip to the latest version
RUN pip install --upgrade pip

RUN pip install \
    tzdata \
    Django==5.0.2 \
    # Production Webserver
    gunicorn \
    # MariaDB connector
    mysqlclient

# Expose the ports for Nginx, Gunicorn and MariaDB
EXPOSE 80 8000 3306

# Copy everything inside container
WORKDIR /application
COPY . .

# Setup Nginx Configuration
RUN mkdir -p /var/log/nginx
COPY nginx.conf /etc/nginx/sites-available/default

# Ensure Nginx picks up the custom configuration
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default


# Set WORKDIR
WORKDIR /application/tracetech

# Set the entrypoint
ENTRYPOINT ["../entrypoint.sh"]

# Start Gunicorn and serve the Django app
CMD ["sh", "-c", "service nginx start && gunicorn tracetech.wsgi:application --bind 0.0.0.0:8000 --access-logfile - --error-logfile -"]