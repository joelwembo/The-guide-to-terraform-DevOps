
aws eks --region us-east-1 update-kubeconfig --name prodxcloud-cluster
kubectl get svc
kubectl get pods
kubectl get pods
kubectl get services


kubectl apply -f k8s/deployment.yaml 


kubectl apply -f k8s/cluster-autoscaler.yaml
kubectl get pods -n kube-system
# kubectl expose deployment prodxcloud-store --type=LoadBalancer --port=80  --target-port=80 -n prodxcloud-store --name=prodxcloud-store
# Expose the application without namespace because we are the default namespace
kubectl expose deployment prodxcloud-store --type=LoadBalancer --port=80  --target-port=80 --name=prodxcloud-store
kubectl get services prodxcloud-store
kubectl get svc

# delete
kubectl delete -f k8s/deployment.yaml 
# multi-cluster command for manual process

# QA Cluster
eksctl create cluster --name prodxcloud-store-qa --nodegroup-name ng-qa --node-type t3.medium --nodes 2
aws eks list-clusters
aws eks --region us-east-1 update-kubeconfig --name prodxcloud-store-qa
kubectl apply -f ./k8s/deployment-qa.yaml
kubectl expose deployment prodxcloud-store-qa --type=LoadBalancer --type=LoadBalancer --port=80  --name=prodxcloud-cluster-qa-service
kubectl get pods
kubectl get services prodxcloud-cluster-qa-service
# Staging Cluster
eksctl create cluster --name prodxcloud-store-staging --nodegroup-name ng-staging --node-type t3.medium --nodes 2
aws eks list-clusters
aws eks --region us-east-1 update-kubeconfig --name prodxcloud-store-staging
kubectl apply -f ./k8s/deployment-staging.yaml
kubectl expose deployment prodxcloud-store-staging --type=LoadBalancer --type=LoadBalancer --port=80  --name=prodxcloud-cluster-staging-service
kubectl get pods
kubectl get services prodxcloud-cluster-staging-service

# helm and karpenter

helm upgrade --install karpenter karpenter/karpenter \
--namespace karpenter \
--create-namespace \
-f /path/to/values.yaml \
--version v0.16.3