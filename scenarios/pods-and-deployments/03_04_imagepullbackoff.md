# ImagePullBackOff: typos, bad registries, private registry creds

Transcript mapping: 03_04_before

Folder: `Exercise Files/03_04_before`
- Files: `app.yaml`, `cluster.yaml`

## Reproduce
```zsh
cd "../../exercise-files/03_04_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl get pods
```
Expected: Pod transitions from `ErrImagePull` to `ImagePullBackOff`.

## Diagnose
1) Describe the Pod for image pull events and container names:
```zsh
kubectl describe pod test-app | sed -n '/Events:/,$p'
```
2) Typical issues:
- Typo in image name (e.g., `brusybox` vs `busybox`).
- Bad registry host (e.g., `dockerrrrrr.io`).
- Private registry requires imagePullSecret.

## Fix
- Typos / bad registries: edit the Pod template in the Deployment or the Pod (if loose pod):
```zsh
kubectl edit pod test-app
# or if it’s a Deployment-backed pod:
# kubectl edit deployment <name>
```
- Private registry: create a secret and reference it in the Pod spec:
```zsh
kubectl create secret docker-registry regcred \
  --docker-server=<REGISTRY> \
  --docker-username=<USER> \
  --docker-password=<PASS> \
  --docker-email=<EMAIL>
# Then add imagePullSecrets:
# imagePullSecrets:
# - name: regcred
```

## Validate
```zsh
kubectl get pods
kubectl describe pod test-app
```
Containers should become Ready after fixes.

## Cleanup
```zsh
kind delete cluster --name kind
```