#!/usr/bin/env bash
kubectl -n kube-system apply -f - <<-YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . 93.184.215.14
        cache 30
        loop
        reload
        loadbalance
    }
YAML
kubectl -n kube-system rollout restart deployment coredns
