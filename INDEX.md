# Course-to-Lab Index

This index maps transcript sections to the exercise folders and the corresponding playbooks in this repo.

## Setup
- 02_04_before — Creating a local Kubernetes cluster with kind
  - Files: app.yaml, cluster.yaml, start_cluster.sh, stop_cluster.sh
  - Playbook: see `scenarios/nodes-control-plane/00_setup_local_cluster.md`

## 3. Pods and Deployments
- 03_01_before — Pending pods: resources, taints/tolerations, pending PVCs
  - Files: app.yaml, app-3.yaml, cluster.yaml
  - Playbook: `scenarios/pods-and-deployments/03_01_pending-pods_taints-pvcs.md`
- 03_04_before — ImagePullBackOff: typos, bad registry, private registry
  - Files: app.yaml, cluster.yaml
  - Playbook: `scenarios/pods-and-deployments/03_04_imagepullbackoff.md`
- 03_07_before — CrashLoopBackOff & liveness probes
  - Files: app.yaml, cluster.yaml
  - Playbook: `scenarios/pods-and-deployments/03_07_crashloopbackoff_liveness.md`
- 03_09_before — Readiness probe failures
  - Files: app.yaml, cluster.yaml
  - Playbook: `scenarios/pods-and-deployments/03_09_readiness_probes.md`
- 03_10_before — Slow pods & HPA
  - Files: app.yaml, cluster.yaml, start_cluster.sh, stop_cluster.sh
  - Playbook: `scenarios/pods-and-deployments/03_10_slow_pods_hpa.md`
- 03_11_before — Challenge: A troublemaking deployment
  - Files: app.yaml, cluster.yaml
  - Playbook: `scenarios/pods-and-deployments/03_11_challenge_troublemaking_deployment.md`

## 4. Networking and Ingress
- 04_01_before — DNS inside pods (custom dnsConfig, Alpine resolv issues)
  - Files: app.yaml, broken-dns.yaml, cluster.yaml, update_dns.sh
  - Playbook: `scenarios/networking-and-ingress/04_01_dns_inside_pods.md`
- 04_04_before — Pod networking & NetworkPolicies
  - Files: app.yaml, cluster.yaml, network-policy.yaml, start_cluster.sh
  - Playbook: `scenarios/networking-and-ingress/04_04_pod_networking_and_networkpolicies.md`
- 04_06_before — Unreachable Services (selectors/targetPort)
  - Files: app.yaml, cluster.yaml
  - Playbook: `scenarios/networking-and-ingress/04_06_services_unreachable.md`
- 04_07_before — Ingress issues (controller, service availability, pathType)
  - Files: app.yaml, cluster.yaml, start_cluster.sh
  - Playbook: `scenarios/networking-and-ingress/04_07_ingress_issues_controller_service_pathType.md`
- 04_10_before — Challenge: The flaky web app
  - Files: challenge.yaml, cluster.yaml, start_cluster.sh
  - Playbook: `scenarios/networking-and-ingress/04_10_challenge_flaky_web_app.md`

## 5. Nodes, Control Plane, and the Kubernetes API
- 05_03_before — kubeconfig & certs (extract, verify, regenerate)
  - Files: start_cluster.sh
  - Playbook: `scenarios/nodes-control-plane/05_03_kubeconfig_certs.md`
- 05_08_before — NotReady nodes: kubelet not started, missing CNI
  - Files: cluster-1.yaml, cluster-2.yaml, start_cluster.sh
  - Playbook: `scenarios/nodes-control-plane/05_08_nodes_kubelet_and_cni.md`
- 05_12_before — Slow deletions & finalizers; namespace finalizer removal via API
  - Files: cluster.yaml, start_cluster.sh
  - Playbook: `scenarios/nodes-control-plane/05_12_finalizers_namespace.md`
