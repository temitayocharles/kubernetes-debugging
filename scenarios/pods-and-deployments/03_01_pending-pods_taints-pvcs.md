# Pending Pods: resources, taints/tolerations, and pending PVCs

Transcript mapping: 03_01_before

Folder: `Exercise Files/03_01_before`
- Files: `app.yaml`, `app-3.yaml`, `cluster.yaml`

## Reproduce
```zsh
cd "../../exercise-files/03_01_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods
```
Expected: one or more Pods Pending.

## Diagnose
1) Describe a Pending Pod (events show why scheduling fails):
```zsh
kubectl describe pod test-app
```
- Look for messages like:
  - "0/2 nodes are available: 1 Insufficient memory, 1 node(s) had untolerated taint ..."
2) Check node capacity/allocatable:
```zsh
kubectl describe node kind-worker | less
```
3) Taints vs tolerations (if taint seen in events):
```zsh
kubectl describe node kind-worker | sed -n '/Taints:/,/^$/p'
```
4) Pending dependencies (PVC): list events for namespace:
```zsh
kubectl get events --sort-by=.lastTimestamp
```
- Look for PVC stuck in Pending (waiting for PV/storage class).

## Fix
- Resources: reduce `resources.requests/limits` in the Pod/Deployment to fit node allocatable, or add another worker with more memory/CPU.
- Taints: add a matching toleration to the Pod template in the Deployment, e.g.:
```yaml
tolerations:
- key: "debugging.k8s.io/ready"
  operator: "Exists"
  effect: "NoSchedule"
```
- PVC wait: temporarily remove the volume mount/volume to confirm it’s the blocker, then correct the StorageClass or provision PV so the PVC binds.
  - For immutable fields in Pods, edit the Deployment (not the Pod) and let it recreate.

## Validate
```zsh
kubectl get pods --show-labels
kubectl describe pod <pod-name>
```
Pods should move to Running after fixes.

## Cleanup
```zsh
kind delete cluster --name kind
```