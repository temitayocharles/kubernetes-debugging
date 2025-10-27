#!/usr/bin/env bash
>&2 echo "INFO: Creating cluster"
kind create cluster --config "$(dirname "$0")/cluster.yaml"
>&2 echo "INFO: Installing Calico"
kubectl apply -f "https://docs.projectcalico.org/manifests/calico.yaml"
>&2 echo "INFO: Deploying broken stuff!"
kubectl apply -f "$(dirname "$0")/app.yaml"
