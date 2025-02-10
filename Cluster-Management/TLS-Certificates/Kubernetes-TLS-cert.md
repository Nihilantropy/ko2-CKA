# Kubernetes TLS Certificates: Practical Guide

## 1. Overview
Kubernetes uses TLS certificates to secure communication between its components and to authenticate requests within the cluster. This document details the practical steps required after generating the necessary certificates.

## 2. Placement of Certificates
Once the certificates are generated, they should be stored in specific locations on the Kubernetes control plane nodes.

### 2.1 Certificate Storage Path
Most certificates should be placed in:
```
/etc/kubernetes/pki/
```

This ensures they are available for Kubernetes components such as the API Server, Controller Manager, Scheduler, etc.

## 3. Certificate Usage in Kubernetes Components
Each Kubernetes component uses TLS certificates to authenticate and authorize communication within the cluster.

### 3.1 CA Certificate (`ca.crt`)
Every Kubernetes service (API Server, Controller Manager, Scheduler, Etcd, etc.) must have access to `ca.crt` to validate other component certificates.

### 3.2 API Server
- **Files Required:**
  - `apiserver.crt`, `apiserver.key` (API Server's TLS cert & key)
  - `apiserver-kubelet-client.crt`, `apiserver-kubelet-client.key` (Used for API Server authentication with kubelet)
  - `ca.crt` (to validate other services)
- **Placement:**
  - Store in `/etc/kubernetes/pki/`
- **Usage:**
  - The API Server references these certificates in its **static Pod manifest** at:
    ```yaml
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    ```

### 3.3 Controller Manager
- **Files Required:**
  - `controller-manager.crt`, `controller-manager.key` (Controller Manager's TLS cert & key)
  - `ca.crt` (to validate other services)
- **Placement:**
  - Store in `/etc/kubernetes/pki/`
- **Usage:**
  - The Controller Manager references these certificates in `/etc/kubernetes/controller-manager.conf`:
    ```yaml
    apiVersion: v1
    kind: Config
    clusters:
    - cluster:
        certificate-authority: /etc/kubernetes/pki/ca.crt
      name: kubernetes
    contexts:
    - context:
        cluster: kubernetes
        user: system:kube-controller-manager
      name: kube-controller-manager
    current-context: kube-controller-manager
    users:
    - name: system:kube-controller-manager
      user:
        client-certificate: /etc/kubernetes/pki/controller-manager.crt
        client-key: /etc/kubernetes/pki/controller-manager.key
    ```

### 3.4 Scheduler
- **Files Required:**
  - `scheduler.crt`, `scheduler.key` (Scheduler's TLS cert & key)
  - `ca.crt` (to validate other services)
- **Placement:**
  - Store in `/etc/kubernetes/pki/`
- **Usage:**
  - The Scheduler references these certificates in `/etc/kubernetes/scheduler.conf`:
    ```yaml
    apiVersion: v1
    kind: Config
    clusters:
    - cluster:
        certificate-authority: /etc/kubernetes/pki/ca.crt
      name: kubernetes
    contexts:
    - context:
        cluster: kubernetes
        user: system:kube-scheduler
      name: kube-scheduler
    current-context: kube-scheduler
    users:
    - name: system:kube-scheduler
      user:
        client-certificate: /etc/kubernetes/pki/scheduler.crt
        client-key: /etc/kubernetes/pki/scheduler.key
    ```

### 3.5 Etcd
- **Files Required:**
  - `etcd-server.crt`, `etcd-server.key` (Etcd server TLS cert & key)
  - `etcd-peer.crt`, `etcd-peer.key` (Used for peer communication)
  - `ca.crt` (to validate client requests)
- **Placement:**
  - Store in `/etc/kubernetes/pki/etcd/`
- **Usage:**
  - The Etcd configuration in `/etc/kubernetes/manifests/etcd.yaml` should include:
    ```yaml
    - --cert-file=/etc/kubernetes/pki/etcd/etcd-server.crt
    - --key-file=/etc/kubernetes/pki/etcd/etcd-server.key
    - --peer-cert-file=/etc/kubernetes/pki/etcd/etcd-peer.crt
    - --peer-key-file=/etc/kubernetes/pki/etcd/etcd-peer.key
    - --trusted-ca-file=/etc/kubernetes/pki/ca.crt
    ```

### 3.6 Kubelet
- **Files Required:**
  - `kubelet.crt`, `kubelet.key` (Kubelet's TLS cert & key)
  - `ca.crt` (to validate the API Server)
- **Placement:**
  - Store in `/var/lib/kubelet/pki/`
- **Usage:**
  - Kubelet uses these certificates in `/var/lib/kubelet/config.yaml`:
    ```yaml
    authentication:
      x509:
        clientCAFile: /etc/kubernetes/pki/ca.crt
    tlsCertFile: /var/lib/kubelet/pki/kubelet.crt
    tlsPrivateKeyFile: /var/lib/kubelet/pki/kubelet.key
    ```

### 3.7 Kube Proxy
- **Files Required:**
  - `kube-proxy.crt`, `kube-proxy.key` (Kube Proxy's TLS cert & key)
  - `ca.crt` (to validate API Server requests)
- **Placement:**
  - Store in `/etc/kubernetes/pki/`
- **Usage:**
  - Kube Proxy uses these certificates in `/etc/kubernetes/kube-proxy.conf`:
    ```yaml
    apiVersion: v1
    kind: Config
    clusters:
    - cluster:
        certificate-authority: /etc/kubernetes/pki/ca.crt
      name: kubernetes
    users:
    - name: system:kube-proxy
      user:
        client-certificate: /etc/kubernetes/pki/kube-proxy.crt
        client-key: /etc/kubernetes/pki/kube-proxy.key
    ```

## 4. Kubernetes Configuration File (`kubeconfig`)
The `kubeconfig` file is used to authenticate requests using the generated certificates. Each service has a configuration file such as:
- `/etc/kubernetes/admin.conf` (for cluster admins)
- `/etc/kubernetes/kubelet.conf` (for kubelet authentication)
- `/etc/kubernetes/controller-manager.conf` (for the controller manager)
- `/etc/kubernetes/scheduler.conf` (for the scheduler)

These files specify authentication information, including client certificates and the CA certificate for validation.

## 5. Summary
- Place generated certificates in the correct directories (`/etc/kubernetes/pki/`).
- Ensure each Kubernetes component references the appropriate certificates.
- The `ca.crt` is used to validate all other certificates.
- The `kubeconfig` files streamline authentication between cluster components.

## 6. Next Steps
- Verify that each component is correctly configured to use its respective certificates.
- Restart Kubernetes services to apply the changes.
- Use `kubectl` to validate cluster authentication:
  ```bash
  kubectl get nodes --kubeconfig=/etc/kubernetes/admin.conf
  ```

