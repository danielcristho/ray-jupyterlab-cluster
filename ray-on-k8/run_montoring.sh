#!/bin/bash


# add prometheus
cd kuberay/ && ./install/prometheus/install.sh
kubectl get all -n prometheus-system
kubectl port-forward prometheus-prometheus-kube-prometheus-prometheus-0 -n prometheus-system 9090:9090

# add grafana
kubectl apply -f kuberay/ray-operator/config/samples/ray-cluster.embed-grafana.yaml
kubectl port-forward deployment/prometheus-grafana -n prometheus-system 3000:3000

