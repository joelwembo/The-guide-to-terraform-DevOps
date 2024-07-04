#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo '<!doctype html>
<html lang="en"><h1>EC2 running website</h1></br>
<h3>First Instance</h3>
</html>' | sudo tee /var/www/html/index.html
