#!/usr/bin/env bash
set -x
>&2 echo "INFO: Creating cluster with unhealthy worker nodes"
kind create cluster --config "$(dirname "$0")/cluster-1.yaml"
if ! docker exec -it kind-worker grep -q invalid-argument /var/lib/kubelet/kubeadm-flags.env
then
  docker exec -it kind-worker sed -Ei 's/"$/ --invalid-argument"/g' /var/lib/kubelet/kubeadm-flags.env
  docker exec -it kind-worker systemctl restart kubelet
fi

>&2 echo "INFO: Creating a cluster without a control plane."
kind create cluster --config "$(dirname "$0")/cluster-2.yaml"
>&2 echo "INFO: Selecting first cluster."
kubectl config use-context kind-kind
