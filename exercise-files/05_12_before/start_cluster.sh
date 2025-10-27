#!/usr/bin/env bash
>&2 echo "INFO: Creating cluster"
kind create cluster --config "$(dirname "$0")/cluster.yaml"
>&2 echo "INFO: Create our test pod."
kubectl run --image=bash delete-me -- sh -c 'while true; do "Doing work"; sleep 1; done'
kubectl patch pod delete-me --type json --patch='[ { "op": "replace", "path": "/metadata/finalizers", "value": [debugging.k8s.io/fake-finalizer] } ]'
>&2 echo "INFO: Creating test namespace"
kubectl apply -f "$(dirname "$0")/namespace.yaml"
