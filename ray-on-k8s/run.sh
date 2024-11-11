#!/bin/bash

# create cluster using kind
# kind create cluster --image=kindest/node:v1.26.0

# cek cluster using minikube
minikube_status=$(minikube status --format='{{.Host}}')
if [ "$minikube_status" == "Running" ]; then
    echo "Minikube is already running."
else
    echo "Minikube is not running. Starting Minikube..."
    minikube start
    if [ $? -eq 0 ]; then
        echo "Minikube started successfully."
    else
    echo "Failed to start Minikube. Please check for errors."
    fi
fi

# clone Kuberay repo
if [ -d "kuberay" ]; then
    echo "Directory 'kuberay' already exists, skipping clone."
else
    git clone https://github.com/ray-project/kuberay.git
fi

# Deploy a Kuberay operator
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
helm install kuberay-operator kuberay/kuberay-operator --version 1.2.2
kubectl get pods

# Deploy a ray cluster custom resource
helm install raycluster kuberay/ray-cluster --version 1.2.2
kubectl get rayclusters
kubectl get pods --selector=ray.io/cluster=raycluster-kuberay

# forwarding ray dashboard
# kubectl port-forward service/raycluster-kuberay-head-svc 8265:8265
kubectl port-forward service/raycluster-kuberay-head-v5bm 8265:8265

# Deploy ray job
kubectl apply -f ray_job.yaml
sleep 180
kubectl get rayjob
kubectl get raycluster
kubectl get pods
kubectl get rayjobs.ray.io rayjob-sample -o json | jq '.status.jobStatus'
# kubectl get rayjobs.ray.io rayjob-sample -o jsonpath='{.status.jobStatus}'
# kubectl get rayjobs.ray.io rayjob-sample -o jsonpath='{.status.jobDeploymentStatus}'

# Deploy ray service
kubectl apply -f ray_service.yaml
sleep 180
kubectl get pods -l=ray.io/is-ray-node=yes
kubectl get rayservice
kubectl get raycluster

# test ray cluster
export HEAD_POD=$(kubectl get pods --selector=ray.io/node-type=head -o custom-columns=POD:metadata.name --no-headers)
echo $HEAD_POD
kubectl exec -it $HEAD_POD -- python -c "import ray; ray.init(); print(ray.cluster_resources())"
