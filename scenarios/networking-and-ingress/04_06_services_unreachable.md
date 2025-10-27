# Unreachable Services (selectors/targetPort)

Transcript mapping: 04_06_before

Folder: `Exercise Files/04_06_before`
- Files: `app.yaml`, `cluster.yaml`

## Reproduce
```zsh
cd "../../exercise-files/04_06_before"
kind create cluster --config cluster.yaml
kubectl apply -f app.yaml
kubectl exec -it deployment/app-c -- bash
nc app-d 8080  # expect connection refused
```

## Diagnose
1) Service config:
```zsh
kubectl get svc app-d -o wide
kubectl describe svc app-d
```
- Confirm selector matches pods: `kubectl get pods -l app=app-d`
- Check `targetPort` aligns with container `containerPort`.
2) Pod exposure:
```zsh
kubectl describe pod -l app=app-d | grep -i 'Port' -n
```

## Fix
- If Service `targetPort` mismatches container port (e.g., svc=8080 -> container=80), edit the Service:
```zsh
kubectl edit service app-d
# set: targetPort: 80
```

## Validate
```zsh
kubectl exec -it deployment/app-c -- bash
nc app-d 8080  # should return HTTP 200 and Hello
```

## Cleanup
```zsh
kind delete cluster --name kind
```