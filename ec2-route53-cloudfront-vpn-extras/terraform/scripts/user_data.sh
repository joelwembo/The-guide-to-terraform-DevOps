#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo '<!doctype html>
<html lang="en"><h1>AWS EC2 running website</h1></br>
<h3>AWS EC2 First Instance</h3>
</html>' | sudo tee /var/www/html/index.html
exit

# ssh -i "prodxcloud-ec2-keypair-1.pem" ubuntu@ec2-54-83-157-26.compute-1.amazonaws.com
# ssh -i "prodxcloud-ec2-keypair-1.pem" ubuntu@54.83.157.26