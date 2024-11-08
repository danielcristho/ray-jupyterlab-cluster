#!/bin/bash

minikube_status=$(minikube status --format='{{.Host}}')
if [ "$minikube_status" == "Running" ]; then
    echo "Minikube is already running."
else
    echo "Minikube is not running. Starting Minikube..."
    minikube start \
        --kubernetes-version stable \
        --nodes 2 \
        --cpus 2 \
        --memory 2000 \
        --cni calico
    if [ $? -eq 0 ]; then
        echo "Minikube started successfully."
    else
    echo "Failed to start Minikube. Please check for errors."
    fi
fi

helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm repo update
helm upgrade --cleanup-on-fail --install jupyter-hub jupyterhub/jupyterhub --namespace k8s-jupyter --create-namespace --values config.yaml
kubectl get pods -n k8s-jupyter
kubectl get svc -n k8s-jupyter
minikube service -n k8s-jupyter proxy-public