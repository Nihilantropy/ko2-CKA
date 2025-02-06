## **9. Managing Storage and Persistent Volumes**

### Basic Commands:

- **View persistent volume claims (PVCs):**
  ```sh
  kubectl get pvc
  ```

- **Describe a persistent volume (PV):**
  ```sh
  kubectl describe pv <pv-name>
  ```

- **Get storage classes available in the cluster:**
  ```sh
  kubectl get storageclass
  ```

### Advanced Commands:

- **List persistent volume claims in a specific namespace:**
  ```sh
  kubectl get pvc -n <namespace>
  ```

- **Check the status of persistent volume claims:**
  To view if PVCs are bound, pending, or failed.
  ```sh
  kubectl get pvc -o wide
  ```

- **Get detailed information about a PVC:**
  ```sh
  kubectl describe pvc <pvc-name> -n <namespace>
  ```

- **List persistent volumes in the cluster:**
  ```sh
  kubectl get pv
  ```

- **View the events related to storage (e.g., provisioning, binding, or error events):**
  ```sh
  kubectl get events --field-selector involvedObject.kind=PersistentVolumeClaim
  ```

- **Inspect the PVC and PV binding details:**
  ```sh
  kubectl describe pvc <pvc-name> -n <namespace> | grep "Volume"
  kubectl describe pv <pv-name> | grep "Claim"
  ```

- **View details about a specific storage class:**
  ```sh
  kubectl describe storageclass <storageclass-name>
  ```

- **Check which persistent volume claim is bound to which persistent volume:**
  ```sh
  kubectl get pvc <pvc-name> -o jsonpath='{.spec.volumeName}'
  kubectl get pv <pv-name> -o jsonpath='{.spec.claimRef.name}'
  ```

- **Manually delete a PVC and its associated PV (if not bound to a pod):**
  ```sh
  kubectl delete pvc <pvc-name> -n <namespace>
  kubectl delete pv <pv-name>
  ```

- **Get information about the underlying storage (e.g., NFS, GlusterFS, etc.) used in a PVC:**
  ```sh
  kubectl describe pv <pv-name> | grep "Source"
  ```

### Complex and Real-World Use Cases:

- **Provisioning a new persistent volume from a specific storage class:**
  To create a PVC from a particular storage class for applications with specific storage requirements (e.g., SSD or standard storage).
  ```sh
  kubectl apply -f - <<EOF
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: my-claim
    namespace: <namespace>
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
    storageClassName: <storageclass-name>
  EOF
  ```

- **Troubleshooting PVC binding issues (e.g., PVC is stuck in "Pending"):**
  1. Check the storage class and ensure that the required provisioner is available.
     ```sh
     kubectl describe pvc <pvc-name> -n <namespace>
     kubectl describe storageclass <storageclass-name>
     ```
  2. Verify the available PVs and their storage class to ensure there are suitable PVs for binding.
     ```sh
     kubectl get pv -o wide
     ```
  3. Check for events related to the PVC.
     ```sh
     kubectl get events --field-selector involvedObject.kind=PersistentVolumeClaim
     ```

- **Expanding a persistent volume claim (PVC) to use more storage:**
  When a PVC is running out of space and needs to be expanded, you can update the claim:
  ```sh
  kubectl patch pvc <pvc-name> -n <namespace> -p '{"spec": {"resources": {"requests": {"storage": "20Gi"}}}}'
  ```

- **Rebinding a PVC to a different PV after unbinding:**
  If you need to move a PVC to a different volume, delete the PVC and create a new PVC with the desired PV:
  ```sh
  kubectl delete pvc <pvc-name> -n <namespace>
  kubectl apply -f new-pvc-definition.yaml
  ```

- **Backing up and restoring data from persistent volumes (e.g., using snapshots):**
  If your storage class supports snapshots, you can take snapshots and restore from them. For example, with the `gce-pd` provisioner:
  - Create a snapshot:
    ```sh
    kubectl snapshot pvc <pvc-name> -n <namespace> --name <snapshot-name>
    ```
  - Restore from snapshot:
    ```sh
    kubectl restore pvc <snapshot-name> -n <namespace>
    ```

- **Using dynamic provisioning to automatically create volumes based on storage class:**
  When you create a PVC with a specified storage class, Kubernetes will dynamically provision the volume using the configured provisioner (e.g., AWS EBS, GCE PD, etc.).
  ```sh
  kubectl apply -f - <<EOF
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: auto-provisioned-pvc
    namespace: <namespace>
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 5Gi
    storageClassName: <storageclass-name>
  EOF
  ```

- **Managing storage with StatefulSets (use case for applications requiring stable persistent storage):**
  StatefulSets are used for applications that require stable, persistent storage across pod rescheduling.
  ```sh
  kubectl apply -f statefulset.yaml
  ```

  Example `statefulset.yaml` that defines persistent volumes:
  ```yaml
  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: mysql
  spec:
    serviceName: "mysql"
    replicas: 3
    selector:
      matchLabels:
        app: mysql
    template:
      metadata:
        labels:
          app: mysql
      spec:
        containers:
        - name: mysql
          image: mysql:5.6
          volumeMounts:
          - name: mysql-persistent-storage
            mountPath: /var/lib/mysql
    volumeClaimTemplates:
    - metadata:
        name: mysql-persistent-storage
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi
        storageClassName: <storageclass-name>
  ```

- **Handling multiple persistent volumes in large applications (e.g., separate volumes for data and logs):**
  Create separate PVCs for different storage needs within a single application:
  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: app-data-pvc
    namespace: <namespace>
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 50Gi
    storageClassName: <storageclass-name>
  ```

  Similarly, create another PVC for logs:
  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: app-logs-pvc
    namespace: <namespace>
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
    storageClassName: <storageclass-name>
  ```

### Troubleshooting Real-World Scenarios:

- **PVC is stuck in the "Pending" state:**
  1. Check the PVC and PV binding status:
     ```sh
     kubectl describe pvc <pvc-name> -n <namespace>
     kubectl describe pv <pv-name>
     ```
  2. Ensure that the storage class provisioner is correctly set up in the cluster.
  3. Verify that sufficient resources (e.g., available capacity in the storage backend) are available.

- **Failed volume mount in a pod due to insufficient permissions:**
  If a pod is failing to mount a PVC, check for correct access permissions:
  ```sh
  kubectl describe pod <pod-name> -n <namespace>
  kubectl describe pvc <pvc-name> -n <namespace>
  ```
  Look for errors related to volume mount failures and ensure the correct roles and role bindings are applied.
