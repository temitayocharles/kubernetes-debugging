# Challenge: A troublemaking deployment (solution)

Transcript mapping: 03_11_before

Folder: `Exercise Files/03_11_before`
- Files: `app.yaml`, `cluster.yaml`

## Goal
- Deploy `app.yaml` and get the Deployment healthy.
- Requirements: all containers Ready; do not modify `container-2` command; verify logs from both containers.

## Steps
```zsh
cd "../../exercise-files/03_11_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods --show-labels
```
1) Inspect ImagePullBackOff:
```zsh
kubectl describe pod -l app=test-app | sed -n '/Containers:/,/Events:/p'
```
- Fix image typo (e.g., `bisybrox` -> `busybox`) by editing the Deployment:
```zsh
kubectl edit deployment test-app
```
2) CrashLoopBackOff:
```zsh
kubectl logs deployment/test-app
```
- Remove invalid command (e.g., `invalid-command`) in container command (still via Deployment edit).
3) Readiness: do NOT alter `container-2` command. Adjust the readiness probe for timing (e.g., `periodSeconds`/`failureThreshold`) or wait until it becomes ready if it has a long sleep.

## Validate
- Both containers Ready:
```zsh
kubectl get pods -l app=test-app
kubectl logs deployment/test-app --all-containers
```
You should see the two expected log messages indicating completion.

## Cleanup
```zsh
kind delete cluster --name kind
```