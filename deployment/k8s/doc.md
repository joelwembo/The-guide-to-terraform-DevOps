kubectl expose deployment prodxcloud-store --type=NodePort --port=80

minikube service prodxcloud-store --url