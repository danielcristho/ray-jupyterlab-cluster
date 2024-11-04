#!/bin/bash

# Download Kuberay repo
if [ -d "kuberay" ]; then
    echo "Directory 'kuberay' already exists, skipping clone."
else
    git clone https://github.com/ray-project/kuberay.git
fi

# Create cluster
kind create cluster --image=kindest/node:v1.26.0

# Deploy a Kuberay operator
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
helm install kuberay-operator kuberay/kuberay-operator --version 1.2.2
kubectl get pods

# Deploy a RayCluster custom resource
helm install raycluster kuberay/ray-cluster --version 1.2.2
kubectl get rayclusters
kubectl get pods --selector=ray.io/cluster=raycluster-kuberay

# Deploy rayjob
kubectl apply -f ray_job.yaml
kubectl get rayjob
kubectl get raycluster
kubectl get pods
kubectl get rayjobs.ray.io rayjob-sample -o jsonpath='{.status.jobStatus}'
kubectl get rayjobs.ray.io rayjob-sample -o jsonpath='{.status.jobDeploymentStatus}'
kubectl logs -l=job-name=rayjob-sample