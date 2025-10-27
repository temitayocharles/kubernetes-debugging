# DNS inside pods: custom dnsConfig, Alpine resolver issues, CoreDNS

Transcript mapping: 04_01_before

Folder: `Exercise Files/04_01_before`
- Files: `app.yaml`, `broken-dns.yaml`, `cluster.yaml`, `update_dns.sh`

## Reproduce
```zsh
cd "../../exercise-files/04_01_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods
```
Expected: a `custom-dns` Deployment crashes or can’t resolve external names.

## Diagnose
1) App logs:
```zsh
kubectl logs -l app=custom-dns -f
```
2) Inspect pod-level DNS config (not always visible in describe):
```zsh
kubectl get pod -l app=custom-dns -o yaml | less
# look for: dnsConfig: nameservers: [IP], dnsPolicy: None
```
3) Validate name server from inside the cluster using netshoot:
```zsh
kubectl run test --image=nicolaka/netshoot -- nslookup linkedin.com <NAMESERVER_IP>
kubectl logs test -f
```
If timeouts -> bad name server; if `SERVFAIL` -> CoreDNS problem.

## Fix (custom DNS)
- Either remove custom `dnsConfig`/`dnsPolicy: None` to use cluster DNS, or replace name server with a valid one (e.g., `1.1.1.1` or `8.8.8.8`).
```zsh
kubectl edit deployment custom-dns
```

## Alpine resolver issue
- If image is old Alpine (e.g., 3.10), upgrade to newer (e.g., 3.20):
```zsh
kubectl exec deployment/old-alpine-linux -- cat /etc/issue
kubectl edit deployment old-alpine-linux  # change image: alpine:3.20
```

## Fix (CoreDNS down/misconfig)
- Edit CoreDNS ConfigMap and restart:
```zsh
kubectl edit cm -n kube-system coredns
# correct upstream in forward plugin, e.g., forward . 8.8.8.8
kubectl rollout restart deployment -n kube-system coredns
```

## Validate
```zsh
kubectl logs -l app=custom-dns -f
kubectl delete pod test --force --grace-period=0 2>/dev/null || true
```

## Cleanup
```zsh
kind delete cluster --name kind
```