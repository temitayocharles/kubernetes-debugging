#!/usr/bin/env bash
>&2 echo "INFO: Deploying cluster"
kind create cluster --name kind
>&2 echo "INFO: Copying created Kubeconfig to exercise files folder"
cp "$HOME/.kube/config" "$(dirname "$0")/kubeconfig"
>&2 echo "INFO: Modifying the kubeconfig"
trap 'rm key.pem cert.pem' INT HUP EXIT
openssl req -x509 \
  -newkey rsa:4096 \
  -keyout key.pem \
  -out cert.pem \
  -sha256 \
  -days 3650 \
  -nodes \
  -subj '/CN=localhost/O=system:masters' \
  -quiet
yq -i \
  '(.users[] | select(.name == "kind-kind") | .user.client-certificate-data) |= '"'"$(base64 -w 0 < cert.pem)"'"' \
  "$(dirname "$0")/kubeconfig"
yq -i \
  '(.users[] | select(.name == "kind-kind") | .user.client-key-data) |= '"'"$(base64 -w 0 < key.pem)"'"' \
  "$(dirname "$0")/kubeconfig"
rm key.pem cert.pem
trap - INT HUP EXIT
