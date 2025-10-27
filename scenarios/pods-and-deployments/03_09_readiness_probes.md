# Readiness probe failures

Transcript mapping: 03_09_before

Folder: `Exercise Files/03_09_before`
- Files: `app.yaml`, `cluster.yaml`

## Reproduce
```zsh
cd "../../exercise-files/03_09_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods --show-labels
```
Expected: Pod Running but containers NotReady.

## Diagnose
- Describe pod and inspect Readiness probe in container spec:
```zsh
kubectl describe pod -l app=test-app-1 | less
```
- Look for `readinessProbe:` (exec) and thresholds; also inspect container command for long sleeps before creating `/tmp/ready`.

## Fix
- Edit Deployment `test-app-1` and either:
  - Reduce startup delay (shorter sleep), or
  - Relax readiness thresholds (increase `timeoutSeconds`, `failureThreshold`, `periodSeconds`).
```zsh
kubectl edit deployment test-app-1
```

## Validate
```zsh
kubectl get pods -l app=test-app-1 -w
```
Should roll to a new replica that becomes Ready while the old one terminates.

## Cleanup
```zsh
kind delete cluster --name kind
```