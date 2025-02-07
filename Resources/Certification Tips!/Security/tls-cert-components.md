# Kubernetes Certificate Generation Guide

## Overview
In a Kubernetes cluster, different components require TLS certificates for secure communication. This guide explains how to generate certificates for:
- **Admin**
- **Scheduler**
- **Controller Manager**
- **Kube Proxy**
- **Kubelet (Client & Server)**
- **etcd (Server & Peer)**
- **API Server** (detailed explanation of required names)

All certificates will be signed by the Kubernetes Certificate Authority (CA).

---

## 1️⃣ Generate Kubernetes CA (if not already created)
First, generate the CA that will sign all certificates.

```sh
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/CN=Kubernetes CA"
```

This creates `ca.crt` (certificate) and `ca.key` (private key), which will be used to sign other certificates.

---

## 2️⃣ Generate Certificates for Kubernetes Components

### **Admin Certificate**
Used for `kubectl` authentication.
```sh
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -out admin.csr -subj "/CN=admin/O=system:masters"
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out admin.crt -days 365 -sha256
```

### **Scheduler Certificate**
```sh
openssl genrsa -out scheduler.key 2048
openssl req -new -key scheduler.key -out scheduler.csr -subj "/CN=system:kube-scheduler"
openssl x509 -req -in scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out scheduler.crt -days 365 -sha256
```

### **Controller Manager Certificate**
```sh
openssl genrsa -out controller-manager.key 2048
openssl req -new -key controller-manager.key -out controller-manager.csr -subj "/CN=system:kube-controller-manager"
openssl x509 -req -in controller-manager.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out controller-manager.crt -days 365 -sha256
```

### **Kube Proxy Certificate**
```sh
openssl genrsa -out kube-proxy.key 2048
openssl req -new -key kube-proxy.key -out kube-proxy.csr -subj "/CN=system:kube-proxy"
openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-proxy.crt -days 365 -sha256
```

### **Kubelet Certificates (Client & Server)**
#### Kubelet Client Certificate (used for authentication with API server)
```sh
openssl genrsa -out kubelet-client.key 2048
openssl req -new -key kubelet-client.key -out kubelet-client.csr -subj "/CN=system:node:kubelet-node/O=system:nodes" # The name of the cert depends on the name of the node, since there could be more nodes (kubelet) in a cluster
openssl x509 -req -in kubelet-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kubelet-client.crt -days 365 -sha256
```

#### Kubelet Server Certificate (used by Kubelet API for TLS communication)
```sh
openssl genrsa -out kubelet-server.key 2048
openssl req -new -key kubelet-server.key -out kubelet-server.csr -subj "/CN=kubelet"
openssl x509 -req -in kubelet-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kubelet-server.crt -days 365 -sha256
```

---

### **etcd Certificates (Server & Peer)**
#### etcd Server Certificate
```sh
openssl genrsa -out etcd-server.key 2048
openssl req -new -key etcd-server.key -out etcd-server.csr -subj "/CN=etcd-server"
openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcd-server.crt -days 365 -sha256
```

#### etcd Peer Certificate (for communication between etcd nodes)
```sh
openssl genrsa -out etcd-peer.key 2048
openssl req -new -key etcd-peer.key -out etcd-peer.csr -subj "/CN=etcd-peer"
openssl x509 -req -in etcd-peer.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcd-peer.crt -days 365 -sha256
```

---

## 3️⃣ API Server Certificate (Detailed Explanation)
The API server requires a certificate that covers multiple names because it is accessed via different means, including:
- **Cluster DNS names:** `kubernetes`, `kubernetes.default`, `kubernetes.default.svc`, `kubernetes.default.svc.cluster.local`
- **Internal IP addresses:** `192.168.0.1` (Cluster IP), `10.0.0.1` (Pod Network IP)
- **External name (if using a Load Balancer):** `api.example.com`

### **Generating API Server Certificate**
#### Step 1: Create a configuration file (apiserver.conf)
```ini
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = kubernetes
[v3_req]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 192.168.0.1
IP.2 = 10.0.0.1
```

#### Step 2: Generate the private key and CSR
```sh
openssl genrsa -out apiserver.key 2048
openssl req -new -key apiserver.key -out apiserver.csr -config apiserver.conf
```

#### Step 3: Sign the certificate with Kubernetes CA
```sh
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver.crt -days 365 -extensions v3_req -extfile apiserver.conf
```

This ensures the API server certificate is valid for all possible ways it can be accessed.

#### API Server Client Certificate for etcd
The API Server must authenticate to etcd using a client certificate:
```sh
openssl req -new -newkey rsa:4096 -nodes -keyout apiserver-etcd-client.key -out apiserver-etcd-client.csr -subj "/CN=kube-apiserver-etcd-client"
openssl x509 -req -in apiserver-etcd-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver-etcd-client.crt -days 365 -sha256
```
Used in the API Server startup with:
```sh
--etcd-cafile=/etc/kubernetes/pki/ca.crt \
--etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt \
--etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
```

#### API Server Client Certificate for Kubelet
The API Server also requires a client certificate to communicate securely with kubelets:
```sh
openssl req -new -newkey rsa:4096 -nodes -keyout apiserver-kubelet-client.key -out apiserver-kubelet-client.csr -subj "/CN=kube-apiserver-kubelet-client"
openssl x509 -req -in apiserver-kubelet-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver-kubelet-client.crt -days 365 -sha256
```
Used in the API Server startup with:
```sh
--kubelet-certificate-authority=/etc/kubernetes/pki/ca.crt \
--kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt \
--kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
```

## **Final Notes**
- Store certificates in `/etc/kubernetes/pki/`.
- Keep `ca.key` secure as it is used to sign all other certificates.
- Automate certificate management using **kubeadm** or tools like **cert-manager** for production.



