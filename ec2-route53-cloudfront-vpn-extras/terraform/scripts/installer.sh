#!/bin/bash

# nginx installation on amazon ec2 2
# sudo yum update 
# sudo yum -y install nginx
# sudo systemctl start nginx
# sudo systemctl enable nginx
# exi

# remove instruction

# sudo service nginx stop
# sudo chkconfig nginx off
# sudo yum remove nginx -y

# nginx installation in ubuntu
sudo apt update 
sudo apt install nginx  --assume-yes
sudo systemctl start nginx
sudo systemctl enable nginx
echo "nginx installed successfully"
exit

# Jenkins installations
# sudo apt update
# apt install make
# sudo apt-get install debian-keyring debian-archive-keyring --assume-yes
# sudo apt-key update
# sudo apt-get update
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
# sudo apt update
# sudo apt install openjdk-11-jre-headless --assume-yes
# sudo java -version
# curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update
# sudo apt-get install jenkins --assume-yes
# # sudo service jenkins status
# echo 'Jenkins successfully installer'

# # Postgres Installation
# # sudo apt update
# # enable repository to install postgresql
# sudo apt install postgresql postgresql-contrib --assume-yes
# # Install PostgreSQ L server and initialize the database 
# # cluster for this server
# # Start the db service
# # systemctl stop postgresql
# systemctl enable postgresql
# systemctl start postgresql
# echo 'Postgresql Installed successfully installer'

# # Docker installation
# sudo apt install apt-transport-https ca-certificates curl software-properties-common --assume-yes
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'
# apt-cache policy docker-ce
# sudo apt install docker-ce --assume-yes
# sudo chmod 777 /var/run/docker.sock


# # sudo systemctl status docker
# echo 'Docker successfully installer'

# # install docker compose
# sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
# sudo chmod +x /usr/local/bin/docker-compose
# docker-compose --version
# echo "Docker Compose Installed successfully installer"

# # install git
# sudo yum install git -y
# echo "Git Installed successfully installer"
# # install terraform
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# sudo yum -y install terraform
# echo "Terraform Installed successfully installer"


# # install minikube
# sudo apt install -y curl wget apt-transport-https
# wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# sudo cp minikube-linux-amd64 /usr/local/bin/minikube
# sudo chmod +x /usr/local/bin/minikube
# minikube version
# echo "Minikube Installed successfully installer"

# # Kubectl installations
# # curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/kubernetes.gpg
# # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
# # sudo apt install kubeadm kubelet kubectl -y
# # sudo apt-mark hold kubeadm kubelet kubectl -y
# # echo "Kubeclt Installed successfully installer"

# curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x ./kubectl 
# sudo mv ./kubectl /usr/local/bin
# kubectl version
# echo "Kubeclt Installed successfully installer"

# # Helm Chart Installations

# curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
# sudo apt-get install apt-transport-https --yes
# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt-get update
# sudo apt-get install helm

# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# sudo mv /tmp/eksctl /usr/local/bin 
# eksctl version
# echo "eksctl Installed successfully installer"


# # SonarQube Installations  Installations
# sudo apt-get install openjdk-11-jdk -y
# sudo apt-get install zip -y

# sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.8.0.63668.zip
# sudo unzip sonarqube-9.8.0.63668.zip
# sudo mv sonarqube-9.8.0.63668 /opt/sonarqube
# sudo groupadd sonar
# sudo useradd -d /opt/sonarqube -g sonar sonar
# sudo chown sonar:sonar /opt/sonarqube -R

# # ArgoCD Installations

# wget https://github.com/argoproj/argo-cd/releases/download/v2.4.14/argocd-linux-amd64
# chmod +x argocd-linux-amd64
# sudo mv argocd-linux-amd64 /usr/local/bin/argocd
# # argocd login argocd.k3s.differentpla.net
# # argocd login --core
# # kubectl create namespace argocd
# # kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# # kubectl get pods -n argocd
# # kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",  "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'
# # kubectl port-forward svc/argocd-server -n argocd 8383:443 --address 0.0.0.0 &

# # sudo usermod -a -G docker jenkins
# # sudo usermod -a -G docker argocd
# # sudo usermod -a -G docker kubectl

# echo "ArgoCD Installed successfully installer"

# # nginx installation for testing purpose
# # docker run --name my-nginx-server -p 80:80 -d nginx
# # echo "nginx server running in your domain.com at port 80"
