#!/usr/bin/env bash
kind create cluster --config "$(dirname "$0")/cluster.yaml"
>&2 echo "INFO: Installing metrics server"
kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
>&2 echo "INFO: Patching metrics server to make it work within Kind"
kubectl patch -n kube-system deployment metrics-server --type=json \
  -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
>&2 echo "INFO: Deleting any test apps found; this might take a minute"
kubectl delete pod -l app=slow-app --grace-period=0
>&2 echo "INFO: Starting test apps"
kubectl apply -f "$(dirname "$0")/app.yaml"
cat <<-EOF
Done! Run these commands to start connections to test apps"

{ while true; do kubectl port-forward svc/slow-app 8080:8080 &>/dev/null; done; } &
{ while true; do kubectl port-forward svc/fast-app 8081:8081 &>/dev/null; done; } &

Afterwards, run these commands to see a summary of each app's performance:

- Fast app: while true; do curl -sS localhost:8081; sleep 0.1; done
- Slow app: while true; do curl -sS localhost:8080 2>/dev/null; sleep 0.1; done
EOF
