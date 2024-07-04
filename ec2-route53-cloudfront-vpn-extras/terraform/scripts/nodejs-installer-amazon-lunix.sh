#!/bin/bash

# Update package index
sudo yum update -y
# Install prerequisites
sudo yum install -y curl
# Add NodeSource repository for Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
# Install Node.js 18
sudo yum install -y nodejs
# Verify installation
echo "Node.js version:"
node -v
echo "npm version:"
npm -v

# nginx installer for amazon lunix 2
# # Update package index
sudo yum update -y
# Install the Extra Packages for Enterprise Linux (EPEL) repository
sudo amazon-linux-extras install epel -y
# Install Nginx
sudo yum install -y nginx
# Start Nginx service
sudo systemctl start nginx
# Enable Nginx to start on boot
sudo systemctl enable nginx

# Print Nginx status
# sudo systemctl status nginx
