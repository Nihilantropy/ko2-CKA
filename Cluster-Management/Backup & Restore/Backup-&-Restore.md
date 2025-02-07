# Kubernetes Cluster Backup and Restore Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Backup of Cluster Resource Configurations](#backup-of-cluster-resource-configurations)
   - [Why Backup Resource Configurations?](#why-backup-resource-configurations)
   - [Using Velero to Backup Kubernetes Resources](#using-velero-to-backup-kubernetes-resources)
3. [Backup and Restore of etcd](#backup-and-restore-of-etcd)
   - [Backing Up etcd](#backing-up-etcd)
   - [Restoring etcd from a Snapshot](#restoring-etcd-from-a-snapshot)
4. [Restoring the Cluster](#restoring-the-cluster)
   - [Restoring Resource Configurations with Velero](#restoring-resource-configurations-with-velero)
   - [Restoring the Control Plane using an etcd Snapshot](#restoring-the-control-plane-using-an-etcd-snapshot)
5. [Best Practices and Additional Considerations](#best-practices-and-additional-considerations)
6. [Conclusion](#conclusion)

---

## 1. Introduction

Kubernetes clusters run critical workloads and store configuration and state information in two key areas:

- **Resource Configurations:** All Kubernetes objects such as Deployments, Services, ConfigMaps, Secrets, etc., are defined as YAML manifests.  
- **etcd Datastore:** The etcd key-value store holds the cluster’s state, including configurations and status of all cluster objects.

Having a robust backup and restore strategy is essential for disaster recovery, migrating clusters, or recovering from accidental deletions or corruption.

This document covers two main backup strategies:
- **Resource Config Backup:** Using dedicated tools (e.g., Velero) to back up your Kubernetes object manifests.
- **etcd Backup:** Creating snapshots of the etcd datastore and restoring from them if needed.

---

## 2. Backup of Cluster Resource Configurations

### Why Backup Resource Configurations?

- **Version Control:** Resource definitions are often maintained in version control systems (e.g., Git). However, changes applied directly to the cluster may not always be tracked.
- **Disaster Recovery:** In the event of accidental deletion or misconfiguration, having a backup of your Kubernetes objects enables a fast recovery.
- **Migration:** Backups can be used to migrate workloads between clusters.

### Using Velero to Backup Kubernetes Resources

**Velero** is an open-source tool that provides backup, restore, and migration of Kubernetes cluster resources and persistent volumes.

#### A. Installation and Setup

1. **Install Velero CLI:**

   Follow the installation instructions for your platform from the [Velero documentation](https://velero.io/docs/v1.7/basic-install/).

2. **Configure Storage:**

   Velero requires a backup storage location. For example, you can use AWS S3, Google Cloud Storage, or local storage. Example for an S3-compatible storage:
   ```bash
   velero install \
     --provider aws \
     --plugins velero/velero-plugin-for-aws:v1.5.0 \
     --bucket <YOUR_BUCKET_NAME> \
     --secret-file ./credentials-velero \
     --backup-location-config region=<YOUR_AWS_REGION>
   ```

#### B. Creating a Backup

Run the following command to create a backup of all resources in your cluster:

```bash
velero backup create my-cluster-backup --include-namespaces "*" --wait
```

- **`my-cluster-backup`**: The name of your backup.
- **`--include-namespaces "*"`**: Indicates that all namespaces should be backed up.
- **`--wait`**: Waits for the backup to complete before returning.

#### C. Verifying the Backup

Check the status of your backup with:

```bash
velero backup get
```

---

## 3. Backup and Restore of etcd

The etcd datastore is critical because it contains the entire state of the Kubernetes cluster. Backing up etcd ensures you can recover from data corruption or catastrophic failures.

### Backing Up etcd

The following steps assume that you have access to the control plane node(s) and that you’re using a self-hosted etcd cluster. The commands might vary slightly based on your etcd version and configuration.

1. **Set Up Environment Variables:**

   Set the necessary environment variables for etcdctl (adjust based on your certificate paths):
   ```bash
   export ETCDCTL_API=3
   export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
   export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt
   export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key
   ```

2. **Take a Snapshot:**

   Run the following command to create an etcd snapshot:
   ```bash
   sudo etcdctl snapshot save /var/backups/etcd-snapshot.db
   ```
   You can specify a different path as needed.

3. **Verify the Snapshot:**

   Check the snapshot status:
   ```bash
   sudo etcdctl snapshot status /var/backups/etcd-snapshot.db
   ```

### Restoring etcd from a Snapshot

Restoring etcd is typically part of recovering a cluster. Follow these steps to restore the snapshot:

1. **Stop the kube-apiserver (if necessary):**

   Ensure that the control plane services are stopped to prevent interference during the restore.

2. **Restore the Snapshot:**

   Choose a restore directory and run:
   ```bash
   sudo etcdctl snapshot restore /var/backups/etcd-snapshot.db --data-dir /var/lib/etcd-from-backup
   ```
   This command creates a new etcd data directory from your snapshot.

3. **Update the etcd Pod or Systemd Service Configuration:**

   Modify the configuration to point to the new data directory (`/var/lib/etcd-from-backup`).

4. **Restart etcd:**

   Start etcd (or the control plane) so that the restored etcd data is in use.

5. **Verify Cluster State:**

   Once etcd is restored and running, check the cluster’s state using:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

---

## 4. Restoring the Cluster

Restoration involves both recovering resource configurations and, if needed, restoring etcd.

### Restoring Resource Configurations with Velero

1. **List Available Backups:**
   ```bash
   velero backup get
   ```

2. **Restore a Backup:**
   ```bash
   velero restore create my-cluster-restore --from-backup my-cluster-backup --wait
   ```
   - **`my-cluster-restore`**: The name for your restore operation.
   - **`--from-backup my-cluster-backup`**: Specifies which backup to restore from.

3. **Verify Restored Resources:**
   Check that the resources have been restored:
   ```bash
   kubectl get all --all-namespaces
   ```

### Restoring the Control Plane using an etcd Snapshot

If you need to restore the entire cluster state from an etcd snapshot:

1. **Follow the etcd Restore Process:**
   Use the steps in the [Backing Up etcd](#backing-up-etcd) section to restore your etcd snapshot.
2. **Reconfigure Control Plane Components:**
   Ensure that the Kubernetes API server and other control plane components are configured to use the restored etcd data directory.
3. **Restart the Cluster:**
   Restart the necessary services (kube-apiserver, kube-controller-manager, etc.) and validate that the cluster returns to a healthy state.

---

## 5. Best Practices and Additional Considerations

- **Regular Backups:**  
  Schedule regular backups of both your Kubernetes resource configurations and etcd data.

- **Secure Storage:**  
  Store backup files in a secure, redundant location (e.g., cloud storage with versioning enabled).

- **Test Restores:**  
  Regularly perform test restores in a staging environment to verify that your backup process is working correctly.

- **Documentation:**  
  Maintain detailed documentation of your backup and restore procedures, including commands and configuration details.

- **Automation:**  
  Consider automating backups using cron jobs or integrated CI/CD pipelines to reduce the risk of human error.

---

## 6. Conclusion

A robust backup and restore strategy is critical for maintaining the integrity and availability of your Kubernetes cluster. By combining resource configuration backups using tools like Velero with periodic etcd snapshots, you can ensure that you are prepared for disasters and system failures. Regular testing and adherence to best practices will help minimize downtime and data loss.

This documentation provides a comprehensive guide for backup and restore operations in Kubernetes. Adapt the procedures to fit your cluster environment and backup storage solutions.
