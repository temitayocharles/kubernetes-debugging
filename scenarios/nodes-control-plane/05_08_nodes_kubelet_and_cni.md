# NotReady nodes: kubelet not started, missing CNI

Transcript mapping: 05_08_before

Folder: `Exercise Files/05_08_before`
- Files: `cluster-1.yaml`, `cluster-2.yaml`, `start_cluster.sh`

## Reproduce
```zsh
cd "../../exercise-files/05_08_before"
./start_cluster.sh
kubectl get nodes  # NotReady worker expected
```

## Diagnose (kubelet not running or bad flags)
- Exec into the kind worker and inspect kubelet:
```zsh
docker exec -it kind-worker bash
ps -ef | grep kubelet
systemctl status kubelet
# Inspect drop-ins
cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
cat /var/lib/kubelet/kubeadm-flags.env
# remove invalid flags with sed if present
sed -i 's/--invalid-argument[^ ]* //g' /var/lib/kubelet/kubeadm-flags.env
systemctl restart kubelet
systemctl status kubelet
exit
```
- Re-check nodes:
```zsh
kubectl get nodes
```

## Diagnose/Fix (missing CNI)
- In a no-CNI cluster context, nodes will stick at NotReady; conditions show `NetworkPluginNotReady`.
- Install Calico (example):
```zsh
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml
kubectl -n calico-system rollout status deploy/tigera-operator --timeout=180s || true
watch -n 1 kubectl get pods -A  # wait for calico-node and typha to be Running
```

## Validate
```zsh
kubectl get nodes
```
Nodes should become Ready once kubelet is running and CNI is initialized.

## Cleanup
```zsh
kind delete cluster --name kind
```