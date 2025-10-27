# Local Machine Setup (Concise)

Purpose: run the course labs with kind while keeping your machines light. Two setups:
- Intel MacBook: Colima (Docker runtime) + kind
- Apple Silicon Mac mini (with OrbStack installed): OrbStack (Docker engine) + kind (no other k8s)

## 0) Install tooling (both machines)

```bash
brew install colima docker kubectl kind yq
# OrbStack is already installed on the Mac mini (if not: https://orbstack.dev/)
```

## 1) Intel MacBook: Colima + kind

- Start Colima with Docker runtime only (no Kubernetes):
```bash
colima start --runtime docker --cpu 4 --memory 8 --disk 60
# optional if needed: docker context use colima
```
- Verify Docker engine and kubectl:
```bash
docker info | sed -n '1,30p'
kubectl version --client --short
```
- Stop when you’re done to free resources:
```bash
colima stop
```

## 2) Mac mini (Apple Silicon): OrbStack + kind

- Use OrbStack as the Docker engine. Ensure no other local Kubernetes is running.
  - Do not enable any Kubernetes distro (minikube/k3d/microk8s). OrbStack itself doesn’t run k8s by default.
- Verify Docker engine is OrbStack’s:
```bash
docker info | sed -n '1,30p'
```
- Nothing else to start; OrbStack provides the Docker socket.

## 3) kind usage (common to both machines)

- From the repo root:
```bash
cd /Users/charlie/Desktop/kubernetes-debugging
make list   # shows only training-provided scripts
```
- Examples (mirrors the training scripts only):
```bash
make start-04-07   # creates kind cluster, installs ingress controller
make start-04-10   # ingress challenge
make start-03-10   # metrics-server + HPA lab
make stop-03-10    # stop for that lab
make dns-update-04-01  # apply CoreDNS change per lab
```
- Some scenarios require /etc/hosts entries (scripts will prompt). Ingress labs map ports 80/443 in kind configs.

## 4) Keep machines light (headroom tips)

- Run one container engine at a time in your shell session:
  - Intel: `docker context use colima`
  - Apple Silicon: use OrbStack’s default Docker (no change typically needed)
- Close unused port-forward/background jobs between labs.
- Prefer 1 cluster at a time (except labs that explicitly create two, e.g., 05_08).

## 5) Quick checks

```bash
# Which Docker engine am I talking to?
docker context ls
docker info | grep -E "(Server Version|Context|Operating System)" -n

# What k8s contexts exist?
kubectl config get-contexts

# Is my kind cluster healthy?
kubectl get nodes -o wide
kubectl get pods -A
```

## 6) Troubleshooting (quick)

- Port 80/443 busy: stop other local web servers; ensure only one kind cluster with those mappings.
- Context confusion: re-run `docker context use colima` (Intel) or ensure OrbStack is active (Apple); `kubectl config use-context kind-kind` for the current cluster.
- Metrics server issues on kind: training script `start-03-10` already patches with `--kubelet-insecure-tls`.

That’s it. Use the Make targets only where the training included scripts; perform diagnose/fix manually per the playbooks.
