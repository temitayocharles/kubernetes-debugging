# Ingress issues: controller/service availability and pathType

Transcript mapping: 04_07_before

Folder: `Exercise Files/04_07_before`
- Files: `app.yaml`, `cluster.yaml`, `start_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/04_07_before"
./start_cluster.sh
kubectl apply -f app.yaml
kubectl get deploy,svc,ingress -o wide
```
Test ingress from another terminal:
```zsh
curl -v http://my.cluster/
```
Expected: connection issues if controller/service is down or pathType is misconfigured.

## Diagnose
- Describe ingress rules:
```zsh
kubectl describe ingress app-router
kubectl get ingress app-router -o yaml | less
```
- Check backing services/pods readiness:
```zsh
kubectl get svc,pods -A | grep -E 'app-a|app-b'
```
- PathType pitfalls: `Exact` only matches exact path; `Prefix` matches path and subpaths.

## Fix
- Controller down/Core DNS issue: ensure ingress controller is installed and pods are Running (course script handles this).
- Unavailable service: fix underlying readiness (see Services playbook) so ingress backend is healthy.
- PathType: change from `Exact` to `Prefix` where appropriate:
```zsh
kubectl edit ingress app-router
# e.g., pathType: Prefix for /app
```

## Validate
```zsh
curl -v http://my.cluster/app
curl -v http://my.cluster/app-b/anything
```

## Cleanup
```zsh
kind delete cluster --name kind
# Also remove hosts entry for my.cluster if you added one
sudo sed -i '' '/my\.cluster/d' /etc/hosts
```