# Upgrading a Kubernetes Cluster Using Kubeadm – CKA Tips

When upgrading your Kubernetes cluster with kubeadm, you typically upgrade in the following order:

1. **Control Plane Components (Master Node)**
2. **Worker Nodes (Node Components: kubelet, kube-proxy, etc.)**

This guide assumes you’re upgrading to Kubernetes version **v1.31.0** and that your cluster is managed with apt (Debian/Ubuntu-based systems).

---

## 1. Prepare Your Environment

### A. Update the apt Repository

Ensure your Kubernetes apt repository is configured correctly (usually in `/etc/apt/sources.list.d/kubernetes.list`). Then update your package lists:

```bash
sudo apt-get update
```

### B. Verify Available Versions

Use `apt-cache madison` to check available versions for kubeadm, kubelet, and kubectl. This helps ensure that the target version is available.

```bash
apt-cache madison kubeadm
apt-cache madison kubelet
apt-cache madison kubectl
```

Look for the **v1.31.0** release (for example, `1.31.0-1.1`). If it is available, you’re ready to proceed.

---

## 2. Control Plane Upgrade

### A. Plan the Upgrade

Before applying the upgrade, check what upgrades are available and review the plan:

```bash
sudo kubeadm upgrade plan v1.31.0
```

This command shows available versions, deprecated features, and a summary of the upgrade process.

### B. Apply the Upgrade

Apply the upgrade for the control plane components:

```bash
sudo kubeadm upgrade apply v1.31.0
```

This command upgrades the kube-apiserver, kube-controller-manager, kube-scheduler, and other control plane components to **v1.31.0**. Follow any prompts provided by the command.

---

## 3. Upgrade Worker Node Components

### A. Upgrade kubelet and kubectl

Once the control plane upgrade is complete, upgrade kubelet and kubectl on each node. On each node, run:

```bash
sudo apt-get install -y kubelet=1.31.0-1.1 kubectl=1.31.0-1.1
```

### B. Reload and Restart Services

After installing the new versions, reload the systemd daemon and restart kubelet:

```bash
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

### C. Verify Node Status

Verify that nodes are reporting the new version and are in a `Ready` state:

```bash
kubectl get nodes
```

---

## 4. Additional Tips and Best Practices

- **Rolling Upgrade:**  
  Upgrade worker nodes one at a time to maintain cluster capacity. Cordon and drain each node before upgrading, then uncordon once validated:
  ```bash
  kubectl cordon <node-name>
  kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
  # Upgrade kubelet and kubectl as shown above
  kubectl uncordon <node-name>
  ```

- **Backup:**  
  Always backup your etcd and configuration files before performing an upgrade.

- **Review Release Notes:**  
  Read the release notes for v1.31.0 to understand any breaking changes or deprecated APIs.

- **Test in Staging:**  
  If possible, validate the upgrade process in a staging environment before applying it to production.

- **Monitor the Cluster:**  
  After the upgrade, continuously monitor node and pod statuses using:
  ```bash
  kubectl get nodes
  kubectl get pods --all-namespaces -o wide
  ```

- **Rollback Preparedness:**  
  Have rollback procedures documented in case the upgrade fails or issues arise. This might include restoring etcd from backup or re-installing previous versions.

---

## Summary of Key Commands

1. **Update apt repository:**
   ```bash
   sudo apt-get update
   ```

2. **Check available versions:**
   ```bash
   apt-cache madison kubeadm
   apt-cache madison kubelet
   apt-cache madison kubectl
   ```

3. **Plan the upgrade:**
   ```bash
   sudo kubeadm upgrade plan v1.31.0
   ```

4. **Apply the control plane upgrade:**
   ```bash
   sudo kubeadm upgrade apply v1.31.0
   ```

5. **Upgrade worker node components:**
   ```bash
   sudo apt-get install -y kubelet=1.31.0-1.1 kubectl=1.31.0-1.1
   sudo systemctl daemon-reload
   sudo systemctl restart kubelet
   ```

6. **Cordoning, Draining, and Uncordoning (per node):**
   ```bash
   kubectl cordon <node-name>
   kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
   kubectl uncordon <node-name>
   ```

7. **Verify cluster status:**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces -o wide
   ```
