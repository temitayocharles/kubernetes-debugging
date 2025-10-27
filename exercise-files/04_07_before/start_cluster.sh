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
kubectl -n ingress-nginx scale deployment ingress-nginx-controller --replicas=0
>&2 echo "INFO: Deploying broken stuff!"
kubectl apply -f "$(dirname "$0")/app.yaml"
>&2 cat <<-EOF
INFO: All done. Run the command below if you would like to access our example
applications from a web browser:

Mac
====
sudo sh -c 'echo "127.0.0.1 my.cluster" >> /etc/hosts'

Windows Powershell
===================
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1`tlocalhost" -Force
EOF
