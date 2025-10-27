#!/usr/bin/env bash
>&2 echo "INFO: Creating cluster"
kind create cluster --config "$(dirname "$0")/cluster.yaml"
>&2 echo "INFO: Installing NGINX Ingress Controller"
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
>&2 echo "INFO: Waiting for the Ingress Controller to become ready"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
>&2 echo "INFO: Adding app.example.com to /etc/hosts (enter password when asked)"
sudo sh -c 'grep -q "app.example.com" /etc/hosts || echo "127.0.0.1 app.example.com" >> /etc/hosts'
>&2 echo "INFO: Deploying the challenge!"
kubectl apply -f "$(dirname "$0")/challenge.yaml"
