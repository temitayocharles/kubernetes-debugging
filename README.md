# Kubernetes Debugging Labs (replicated from course transcript)

This repo replicates the labs from the "Debugging Kubernetes" course using the transcripts you provided. Each scenario has a concise, step-by-step playbook to reproduce the issue, diagnose it, and apply a fix on macOS using kind.

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
