# [Step 6.1]: Delete the RayCluster CR
# Uninstall the RayCluster Helm chart
helm uninstall raycluster
# release "raycluster" uninstalled

# Note that it may take several seconds for the Ray pods to be fully terminated.
# Confirm that the RayCluster's pods are gone by running
kubectl get pods

# NAME                                READY   STATUS    RESTARTS   AGE
# kuberay-operator-7fbdbf8c89-pt8bk   1/1     Running   0          XXm

# [Step 6.2]: Delete the KubeRay operator
# Uninstall the KubeRay operator Helm chart
helm uninstall kuberay-operator
# release "kuberay-operator" uninstalled

# Confirm that the KubeRay operator pod is gone by running
kubectl get pods
# No resources found in default namespace.

# # [Step 6.3]: Delete the Kubernetes clusteri
# kind delete cluster

kubectl delete -f ray_job.yml
kubectl delete -f kuberay/ray-operator/config/samples/ray-cluster.embed-grafana.yaml
