# Pod networking and NetworkPolicies

Transcript mapping: 04_04_before

Folder: `Exercise Files/04_04_before`
- Files: `app.yaml`, `cluster.yaml`, `network-policy.yaml`, `start_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/04_04_before"
./start_cluster.sh
kubectl get deploy,svc
```
Expected: apps A–C deployed; port-forward may be demonstrated.

## Diagnose (connectivity)
- Readiness: ensure target app is Ready (unready pods won’t accept traffic).
- Port-forward to test service reachability:
```zsh
kubectl port-forward svc/app-a 8080:8080
# in another terminal
curl -v http://localhost:8080
```
- Exec into a pod to test in-cluster connectivity:
```zsh
kubectl exec -it deployment/app-c -- bash
nc app-b 8080
```

## Apply NetworkPolicy and observe block
```zsh
kubectl apply -f network-policy.yaml
# Re-run nc from app-c; it should hang/time out
kubectl get netpol
kubectl edit netpol app-b-policy  # allow app-c via additional podSelector
```

## Validate
- `nc app-b 8080` from app-c should now return `Hello`.

## Cleanup
```zsh
kind delete cluster --name kind
```