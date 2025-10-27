# Setup: Local cluster with kind

Transcript mapping: 02_04_before

Folder: `Exercise Files/02_04_before`
- Files: `app.yaml`, `cluster.yaml`, `start_cluster.sh`, `stop_cluster.sh`

## Reproduce
1) Ensure Docker Desktop is running.
2) Navigate to the folder:
```zsh
cd "../../exercise-files/02_04_before"
```
3) Create cluster (prefer the provided config when present):
```zsh
kind create cluster --config cluster.yaml
```
If name conflicts:
```zsh
kind delete cluster --name kind
kind create cluster --config cluster.yaml
```
4) Deploy app resources:
```zsh
kubectl apply -f app.yaml
```

## Diagnose
- Verify nodes and pods:
```zsh
kubectl get nodes
kubectl get pods -A
```

## Fix
- N/A (setup step). If cluster creation fails, check Docker is running and re-run.

## Validate
- You should see at least one Ready node, and any sample resources from `app.yaml` created.

## Cleanup
```zsh
kind delete cluster --name kind
# or if provided:
./stop_cluster.sh
```