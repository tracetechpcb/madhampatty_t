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
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.10 as the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 \
    && update-alternatives --set python /usr/bin/python3.10

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install Django
RUN pip install Django==5.0.2

# Install Gunicorn - Production Webserver
RUN pip install gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 8000

# Copy the application inside container
COPY application/ ./application

# Set WORKDIR
WORKDIR /application

# Start Gunicorn and serve the Django app
CMD ["gunicorn", "application.wsgi:application", "--bind", "0.0.0.0:8000"]