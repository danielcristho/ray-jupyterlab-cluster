kind create cluster --image=kindest/node:v1.26.0

helm install raycluster kuberay/ray-cluster --version 1.1.1

# # Add the Helm repo
# helm repo add kuberay https://ray-project.github.io/kuberay-helm/
# helm repo update

# # Confirm the repo exists
# helm search repo kuberay --devel

# # Install both CRDs and KubeRay operator v1.1.0.
# helm install kuberay-operator kuberay/kuberay-operator --version 1.1.0

# # Check the KubeRay operator Pod in `default` namespace
# kubectl get pods
# # NAME                                READY   STATUS    RESTARTS   AGE
# # kuberay-operator-6fcbb94f64-mbfnr   1/1     Running   0          17s