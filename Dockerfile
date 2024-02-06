# Use the latest Ubuntu LTS as base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install basic packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Any other customizations or configurations can go here