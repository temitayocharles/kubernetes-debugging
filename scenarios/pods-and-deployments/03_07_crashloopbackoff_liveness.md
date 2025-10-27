# CrashLoopBackOff and failing liveness probes

Transcript mapping: 03_07_before

Folder: `Exercise Files/03_07_before`
- Files: `app.yaml`, `cluster.yaml`

## Reproduce
```zsh
cd "../../exercise-files/03_07_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods --show-labels
```
Expected: Deployment-backed pods with CrashLoopBackOff and/or increasing restart counts.

## Diagnose
1) Logs (often show exit code or failing command):
```zsh
kubectl logs -l app=test-app-2
```
2) Describe pods for probe details and container command:
```zsh
kubectl describe pod -l app=test-app-1 | less
```
- Look for `livenessProbe:` exec, thresholds, and the app command (e.g., sleep before creating /tmp/ready).

## Fix
- App crash (bad command, `exit 1`): edit the Deployment:
```zsh
kubectl edit deployment test-app-2
# remove the errant exit 1 or fix command
```
- Liveness probe too aggressive: tune probe or reduce startup delay in container command:
```zsh
kubectl edit deployment test-app-1
# options:
# - increase initialDelaySeconds / timeoutSeconds / periodSeconds / failureThreshold
# - or make app create /tmp/ready sooner (reduce sleep)
```
- If backoff is long, force recreate the pod:
```zsh
kubectl delete pod -l app=test-app-1 --grace-period=0 --force
```

## Validate
```zsh
kubectl get pods -l app=test-app-1 -w
kubectl get pods -l app=test-app-2 -w
```
Pods should reach Running and stop restarting.

## Cleanup
```zsh
kind delete cluster --name kind
```