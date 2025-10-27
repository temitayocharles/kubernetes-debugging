# Slow pods and Horizontal Pod Autoscaler (HPA)

Transcript mapping: 03_10_before

Folder: `Exercise Files/03_10_before`
- Files: `app.yaml`, `cluster.yaml`, `start_cluster.sh`, `stop_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/03_10_before"
# ensure no other kind cluster is running
kind get clusters || true
./start_cluster.sh
# Follow script instructions (sets up metrics-server, apps, and port-forwards)
```
In a second terminal, generate load against fast/slow apps per the script output.

## Diagnose
- Check pods:
```zsh
kubectl get pods --show-labels
kubectl describe pod -l app=slow-app | less
```
- Look for very low CPU/memory limits (e.g., 1m CPU, 16Mi), failing liveness due to random sleeps, frequent restarts.

## Fix
- Scale with HPA using CPU percentage (low threshold to demonstrate scaling):
```zsh
kubectl autoscale deployment slow-app --cpu-percent=3 --min=1 --max=10
kubectl get hpa
kubectl rollout restart deployment slow-app
```
- Watch scaling:
```zsh
watch -n 0.5 kubectl get pods
```
Note: HPA does not fix crashing apps; it adds replicas to meet CPU targets.

## Validate
- Increased number of `slow-app` replicas and improved response rates from the load generator.

## Cleanup
```zsh
./stop_cluster.sh
# or
kind delete cluster --name kind
```