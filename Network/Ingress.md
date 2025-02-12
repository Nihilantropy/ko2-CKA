# Kubernetes Ingress and Ingress Controller Documentation

## 1. Overview
Kubernetes **Ingress** is an API object that manages external access to services within a cluster, typically via HTTP/HTTPS. An **Ingress Controller** is responsible for fulfilling Ingress rules by routing traffic to the appropriate services.

---
## 2. Ingress
### 2.1 What is Ingress?
Ingress provides externally accessible URLs, SSL termination, and load balancing for Kubernetes services.

### 2.2 Key Features
- **Path-based and Host-based Routing**: Routes traffic to services based on URL paths or domain names.
- **TLS Termination**: Secures traffic using SSL certificates.
- **Load Balancing**: Distributes traffic among multiple backend pods.
- **Rewrite & Redirect**: Supports URL rewrites and HTTP to HTTPS redirection.

### 2.3 Ingress Example
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
  tls:
  - hosts:
    - example.com
    secretName: example-tls
```

---
## 3. Ingress Controller
### 3.1 What is an Ingress Controller?
An Ingress Controller is a component that implements the Ingress API and manages traffic routing.

### 3.2 Popular Ingress Controllers
- **NGINX Ingress Controller** (most common)
- **Traefik** (lightweight and dynamic)
- **HAProxy Ingress** (high performance)
- **Istio Gateway** (for service mesh environments)

### 3.3 Deploying NGINX Ingress Controller
#### Install via Helm:
```sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-ingress ingress-nginx/ingress-nginx
```

#### Verify Installation:
```sh
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

---
## 4. TLS and Security
### 4.1 Configuring TLS
TLS is enabled by creating a Kubernetes Secret with a certificate and key:
```sh
kubectl create secret tls example-tls --cert=cert.pem --key=key.pem
```
Refer to the example Ingress manifest for TLS configuration.

### 4.2 Security Best Practices
- **Use strong TLS ciphers**: Configure secure TLS versions.
- **Enable ModSecurity/WAF**: Protect against web attacks.
- **Restrict External Access**: Define proper network policies.

---
## 5. Troubleshooting
### 5.1 Check Ingress Controller Logs
```sh
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```
### 5.2 Validate Ingress Configuration
```sh
kubectl describe ingress example-ingress
```
### 5.3 Test Ingress Routing
```sh
curl -k https://example.com
```

---
## 6. Conclusion
Ingress and Ingress Controllers provide a scalable way to expose services in Kubernetes. Proper configuration ensures security, reliability, and performance for applications.

---
## 7. References
- [Kubernetes Ingress Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

