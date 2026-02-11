# Kubernetes Debugging Labs 


## Start Here
- Read [START_HERE.md](START_HERE.md) for the chronological playbook.

This repo "Debugging Kubernetes" is a simulation of common problems and errors related to using kubernetes. Each scenario has a concise, step-by-step playbook to reproduce the issue, diagnose it, and apply a fix on macOS using kind.


## Documentation Index
- [INDEX.md](INDEX.md)
- [SETUP-local.md](SETUP-local.md)
- [scenarios/networking-and-ingress/04_01_dns_inside_pods.md](scenarios/networking-and-ingress/04_01_dns_inside_pods.md)
- [scenarios/networking-and-ingress/04_04_pod_networking_and_networkpolicies.md](scenarios/networking-and-ingress/04_04_pod_networking_and_networkpolicies.md)
- [scenarios/networking-and-ingress/04_06_services_unreachable.md](scenarios/networking-and-ingress/04_06_services_unreachable.md)
- [scenarios/networking-and-ingress/04_07_ingress_issues_controller_service_pathType.md](scenarios/networking-and-ingress/04_07_ingress_issues_controller_service_pathType.md)
- [scenarios/networking-and-ingress/04_10_challenge_flaky_web_app.md](scenarios/networking-and-ingress/04_10_challenge_flaky_web_app.md)
- [scenarios/nodes-control-plane/00_setup_local_cluster.md](scenarios/nodes-control-plane/00_setup_local_cluster.md)
- [scenarios/nodes-control-plane/05_03_kubeconfig_certs.md](scenarios/nodes-control-plane/05_03_kubeconfig_certs.md)
- [scenarios/nodes-control-plane/05_08_nodes_kubelet_and_cni.md](scenarios/nodes-control-plane/05_08_nodes_kubelet_and_cni.md)
- [scenarios/nodes-control-plane/05_12_finalizers_namespace.md](scenarios/nodes-control-plane/05_12_finalizers_namespace.md)
- [scenarios/pods-and-deployments/03_01_pending-pods_taints-pvcs.md](scenarios/pods-and-deployments/03_01_pending-pods_taints-pvcs.md)
- [scenarios/pods-and-deployments/03_04_imagepullbackoff.md](scenarios/pods-and-deployments/03_04_imagepullbackoff.md)
- [scenarios/pods-and-deployments/03_07_crashloopbackoff_liveness.md](scenarios/pods-and-deployments/03_07_crashloopbackoff_liveness.md)
- [scenarios/pods-and-deployments/03_09_readiness_probes.md](scenarios/pods-and-deployments/03_09_readiness_probes.md)
- [scenarios/pods-and-deployments/03_10_slow_pods_hpa.md](scenarios/pods-and-deployments/03_10_slow_pods_hpa.md)
- [scenarios/pods-and-deployments/03_11_challenge_troublemaking_deployment.md](scenarios/pods-and-deployments/03_11_challenge_troublemaking_deployment.md)

## Prerequisites (macOS zsh)

- Docker Desktop (or another Docker runtime) running
- Homebrew
- Tools:
  - kind, kubectl, yq
  - Optional helpers: watch, httping, stern (for logs), nicolaka/netshoot image

Install core tools:

```zsh
brew install kind kubectl yq
```

Optional helpers:

```zsh
brew install watch httping
```

Pull the netshoot image (first use will auto-pull; this just speeds things up):

```zsh
docker pull nicolaka/netshoot:latest
```

## How to use these labs

- Each scenario is mapped to a folder under `Exercise Files/` and a playbook in `kubernetes-debugging/scenarios/*`.
- In each playbook, follow the “Reproduce -> Diagnose -> Fix -> Validate -> Cleanup” flow.
- All commands are copyable for zsh. Where `cluster.yaml` or scripts exist, they’re used; otherwise a simple `kind create cluster --name kind` is provided.

## Scenarios

- Pods & Deployments: `scenarios/pods-and-deployments`
- Networking & Ingress: `scenarios/networking-and-ingress`
- Nodes, Control Plane & API: `scenarios/nodes-control-plane`

See `INDEX.md` for an outline mapping transcript sections to exercise folders and playbooks.
