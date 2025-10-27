# Challenge: The flaky web app (solution)

Transcript mapping: 04_10_before

Folder: `Exercise Files/04_10_before`
- Files: `challenge.yaml`, `cluster.yaml`, `start_cluster.sh`

## Goal
- Access `app.example.com`, click the link, and make it work (ingress + backend readiness).

## Steps
```zsh
cd "../../exercise-files/04_10_before"
./start_cluster.sh  # adds hosts entry for app.example.com, provisions cluster
kubectl apply -f challenge.yaml
kubectl get ingress -A -o wide
```
1) Identify ingress and rules:
```zsh
kubectl get ingress app-router -o yaml | less
# /about rule likely pathType: Exact
```
2) Fix pathType:
```zsh
kubectl edit ingress app-router
# change pathType: Exact -> Prefix for /about
```
3) If 503 persists, check backend service/pod readiness:
```zsh
kubectl describe svc app-b
kubectl get pods -l component=app-b
kubectl edit deployment app-b  # align readiness probe port to container port (e.g., 80)
```

## Validate
- Refresh the browser at http://app.example.com and click the link; it should complete the challenge.

## Cleanup
```zsh
kind delete cluster --name kind
# Remove hosts entry (if present)
sudo sed -i '' '/app\.example\.com/d' /etc/hosts
```