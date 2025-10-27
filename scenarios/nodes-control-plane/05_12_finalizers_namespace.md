# Slow deletions & finalizers; namespace finalizer removal via API

Transcript mapping: 05_12_before

Folder: `Exercise Files/05_12_before`
- Files: `cluster.yaml`, `start_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/05_12_before"
./start_cluster.sh
kubectl get pods
kubectl delete pod delete-me  # expected to hang
```

## Diagnose
- Describe shows terminated container, but Pod still Deleting:
```zsh
kubectl describe pod delete-me | less
kubectl get pod delete-me -o yaml | less  # look for metadata.finalizers
```
- Scan cluster for other stuck resources before removing finalizers:
```zsh
kubectl api-resources --namespaced --verbs=list -o name | \
  xargs -n 1 kubectl get --show-kind --ignore-not-found -A | \
  grep -Ei --color 'terminating|terminated|error|failed' || true
```

## Fix (remove Pod finalizer safely)
```zsh
kubectl edit pod delete-me
# remove the entries under metadata.finalizers
```

## Namespace finalizer removal via API
If a namespace is stuck Deleting and editing doesn’t remove it:
1) Prepare files from kubeconfig:
```zsh
# CA cert
kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="kind-kind")].cluster.certificate-authority-data}' \
 | base64 -d > ca.pem
# User cert/key
kubectl config view --raw -o jsonpath='{.users[?(@.name=="kind-kind")].user.client-certificate-data}' | base64 -d > user.pem
kubectl config view --raw -o jsonpath='{.users[?(@.name=="kind-kind")].user.client-key-data}' | base64 -d > user.key
# API server URL
url=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="kind-kind")].cluster.server}')
# Namespace JSON with finalizers removed
kubectl get ns delete-me -o json | jq 'del(.spec.finalizers)' > namespace.json
```
2) Call Kubernetes API finalize endpoint:
```zsh
curl -sS \
  -H "Content-Type: application/json" \
  --cacert ca.pem --cert user.pem --key user.key \
  -X PUT --data-binary @namespace.json \
  "$url/api/v1/namespaces/delete-me/finalize"
```

## Validate
```zsh
kubectl get ns | grep delete-me || echo "namespace removed"
```

## Cleanup
```zsh
kind delete cluster --name kind
```