# kubeconfig and certificates: extract, verify, regenerate

Transcript mapping: 05_03_before

Folder: `Exercise Files/05_03_before`
- Files: `start_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/05_03_before"
brew install openssl coreutils  # if not already
./start_cluster.sh
# This writes a local kubeconfig in this folder
```
If `kubectl --kubeconfig ./kubeconfig get nodes` fails with auth errors, proceed.

## Diagnose (extract certificates)
- Current context and user:
```zsh
alias k='kubectl --kubeconfig ./kubeconfig'
k config current-context
k config view -o jsonpath='{.contexts[?(@.name=="kind-kind")].context.user}'
```
- Extract user cert and key; decode base64:
```zsh
k config view --raw -o jsonpath='{.users[?(@.name=="kind-kind")].user.client-certificate-data}' | base64 -d > cert.pem
k config view --raw -o jsonpath='{.users[?(@.name=="kind-kind")].user.client-key-data}' | base64 -d > key.pem
openssl x509 -in cert.pem -noout -text
```
- Extract cluster CA cert:
```zsh
k config view --raw -o jsonpath='{.clusters[?(@.name=="kind-kind")].cluster.certificate-authority-data}' | base64 -d > server.pem
openssl x509 -in server.pem -noout -text
```
- Verify if user cert is signed by cluster CA:
```zsh
openssl verify -CAfile server.pem cert.pem
# If NOT OK (self-signed), regenerate a user cert signed by cluster CA
```

## Fix (regenerate user cert using kind control-plane)
```zsh
# 1) Generate key and CSR inside control-plane container
docker exec kind-control-plane openssl genrsa -out /tmp/user.key 2048
docker exec kind-control-plane openssl req -new -key /tmp/user.key -out /tmp/user.csr -subj "/CN=new-user/O=system:masters"
# 2) Sign CSR with cluster CA
docker exec kind-control-plane openssl x509 -req -in /tmp/user.csr \
  -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial -out /tmp/user.pem
# 3) Update kubeconfig (base64 line-wrap disabled)
KCF=./kubeconfig
kubectl --kubeconfig "$KCF" config set users.kind-kind.client-certificate-data \
  "$(docker exec kind-control-plane cat /tmp/user.pem | base64 -w 0)"
kubectl --kubeconfig "$KCF" config set users.kind-kind.client-key-data \
  "$(docker exec kind-control-plane cat /tmp/user.key | base64 -w 0)"
```

## Validate
```zsh
kubectl --kubeconfig ./kubeconfig get nodes
```

## Cleanup
```zsh
kind delete cluster --name kind
```