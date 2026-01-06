#!/bin/bash
set -e

LOG_FILE="/var/log/startup-script.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Installing k3s ====="
curl -sfL https://get.k3s.io | sh -

echo "Waiting for k3s to be ready..."
until kubectl get nodes; do
  sleep 5
done

echo "===== Installing Argo CD ====="
kubectl create namespace argocd || true

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD server..."
kubectl wait --for=condition=Available deployment/argocd-server \
  -n argocd --timeout=300s

echo "===== Exposing Argo CD (NodePort) ====="
kubectl patch svc argocd-server -n argocd \
  -p '{
    "spec": {
      "type": "NodePort",
      "ports": [{
        "port": 443,
        "targetPort": 8080,
        "nodePort": 32080
      }]
    }
  }'

echo "===== Fetching Argo CD admin password ====="
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d > /root/argocd-admin-password.txt

echo "Startup completed successfully."
