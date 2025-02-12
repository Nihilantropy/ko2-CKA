# Ingress Controller Documentation

## Overview

An **Ingress Controller** is a Kubernetes component that manages external HTTP(S) traffic to services within a Kubernetes cluster. It acts as a reverse proxy and load balancer for HTTP(S) traffic, providing advanced routing, SSL termination, and URL path-based or host-based routing. The Ingress Controller works by interpreting and implementing `Ingress` resources defined in the Kubernetes API to determine how external traffic should be directed to services inside the cluster.

### Components of an Ingress Controller

To deploy an Ingress Controller from scratch, there are several components required:

1. **Ingress Resource**: A Kubernetes object that defines the routing rules for external HTTP(S) traffic.
2. **Ingress Controller**: A controller that reads Ingress resources and enforces the rules by configuring a reverse proxy (e.g., Nginx, HAProxy, Traefik).
3. **Load Balancer or Service**: Routes traffic from external sources to the Ingress Controller.

#### The Key Components:
- **Ingress Resource**: Specifies how incoming traffic should be routed to different services based on rules (e.g., domain names, URL paths).
- **Ingress Controller**: Implements the routing rules and acts as the reverse proxy.
- **Reverse Proxy (e.g., Nginx, HAProxy)**: The core component that handles the routing and forwarding of HTTP(S) requests to backend services.
- **Service**: Exposes the Ingress Controller to the outside world, often implemented as a `LoadBalancer` or `NodePort`.
- **TLS Termination**: Optional component where SSL/TLS certificates are managed for HTTPS traffic.

## Ingress Controller Deployment

Here are the steps for deploying an Ingress Controller from scratch using **Nginx**.

### 1. Set Up Kubernetes Cluster

Ensure that you have a Kubernetes cluster up and running, with `kubectl` configured to communicate with it. If you're deploying from scratch, follow these steps:

1. **Install Kubernetes**: Set up Kubernetes on your machines (e.g., using `kubeadm` for a self-managed setup).
2. **Ensure `kubectl` Access**: Confirm `kubectl` is configured and able to connect to the cluster.

### 2. Deploy the Nginx Ingress Controller

You can deploy the Nginx Ingress Controller from scratch or use Helm to simplify the process. We'll cover the manual deployment steps here.

#### Step 1: Create Namespace for Ingress Controller

Create a dedicated namespace for the Ingress Controller:

```bash
kubectl create namespace ingress-nginx
```

#### Step 2: Deploy Nginx Ingress Controller

The Nginx Ingress Controller can be deployed using Kubernetes manifests (e.g., a Deployment and Service) or Helm.

Here, we'll use the Kubernetes manifests:

1. **Deployment YAML**: Create a file named `nginx-ingress-controller.yaml`.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
  namespace: ingress-nginx
  labels:
    app: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-ingress-controller
  template:
    metadata:
      labels:
        app: nginx-ingress-controller
    spec:
      containers:
      - name: nginx-ingress-controller
        image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:latest
        ports:
        - containerPort: 80
        - containerPort: 443
        args:
        - /nginx-ingress-controller
        - --configmap=ingress-nginx/controller-config
        - --default-backend-service=ingress-nginx/default-http-backend
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress-controller
  namespace: ingress-nginx
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb" # For AWS use-case, optional
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
    - port: 443
      targetPort: 443
      protocol: TCP
  selector:
    app: nginx-ingress-controller
  type: LoadBalancer # Adjust if needed (e.g., NodePort)
```

2. **Apply the YAML to Kubernetes**:

```bash
kubectl apply -f nginx-ingress-controller.yaml
```

This will deploy the Nginx Ingress Controller with a LoadBalancer Service exposed on ports 80 and 443.

#### Step 3: Verify the Deployment

Check that the Nginx Ingress Controller pods are running:

```bash
kubectl get pods -n ingress-nginx
```

You should see something like:

```
NAME                                        READY   STATUS    RESTARTS   AGE
nginx-ingress-controller-xxxxxxx-yyyyyy     1/1     Running   0          2m
```

Check the Service to ensure it's accessible:

```bash
kubectl get svc -n ingress-nginx
```

### 3. Create an Ingress Resource

Once the Ingress Controller is deployed, you can create an Ingress Resource to define how HTTP traffic should be routed.

1. **Example Ingress Resource**: Create a file named `example-ingress.yaml`.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
```

This defines an Ingress rule that routes traffic for `example.local` to the `example-service` on port 80.

2. **Apply the Ingress Resource**:

```bash
kubectl apply -f example-ingress.yaml
```

### 4. Verify the Ingress Resource

To ensure the Ingress resource is set up properly, run:

```bash
kubectl get ingress
```

### 5. Test the Deployment

Once the Ingress Controller and the Ingress Resource are configured, test the routing by accessing the service using the specified hostname (e.g., `example.local`).

If using a local DNS (e.g., via `/etc/hosts`), point `example.local` to your Ingress Controller’s external IP:

```
<external-ip> example.local
```

Accessing `http://example.local` should route traffic to the defined backend service.

### 6. TLS/SSL Termination (Optional)

To enable TLS termination, you can configure your Ingress resource to use a TLS certificate.

1. **Create a Secret with TLS Certificates**:

```bash
kubectl create secret tls example-tls --cert=path/to/tls.crt --key=path/to/tls.key -n default
```

2. **Update Ingress Resource to Use TLS**:

```yaml
spec:
  rules:
  - host: example.local
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
    - example.local
    secretName: example-tls
```

Apply the updated Ingress resource:

```bash
kubectl apply -f example-ingress.yaml
```

Now, the Ingress Controller will handle HTTPS traffic and perform TLS termination.

## Conclusion

By following the steps above, you can deploy an Ingress Controller from scratch and configure it to route external traffic into your Kubernetes cluster. This approach can be customized with different reverse proxies, TLS termination, and other routing rules depending on your requirements.