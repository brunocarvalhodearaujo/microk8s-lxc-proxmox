#!/usr/bin/env bash

printf "🛠️ Installing and configure ArgoCD\n"

kubectl delete namespace argocd || true
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

if [ "${argocd_ingress_host}" != "" ]; then
  kubectl apply -n argocd -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-cmd-params-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cmd-params-cm
data:
  server.insecure: "true"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-http-ingress
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: "nginx"
  rules:
    - host: ${argocd_ingress_host}
      http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: argocd-server
                port:
                  name: http
EOF
fi

sleep 60

kubectl patch secret -n argocd argocd-secret \
  -p '{"stringData": { "admin.password": "'$(htpasswd -bnBC 10 "" ${argocd_admin_password} | tr -d ':\n')'"}}'
