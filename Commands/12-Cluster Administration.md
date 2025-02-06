## **12. Cluster Administration Commands**

### Basic Commands:

- **Check available API versions and resources:**
  - **API Versions**: This command lists all available API versions in the cluster, which helps you know which version of each API is available for managing resources.
    ```sh
    kubectl api-versions
    ```
  - **API Resources**: This command shows all available resources (e.g., pods, services, deployments) and their corresponding API group.
    ```sh
    kubectl api-resources
    ```

- **Drain a node before maintenance:**
  Draining a node safely evicts all the pods running on it, ensuring that the pods are rescheduled on other available nodes. The `--ignore-daemonsets` flag ensures that daemonsets aren't evicted during this operation.
  ```sh
  kubectl drain <node-name> --ignore-daemonsets
  ```
  - You can also add `--delete-emptydir-data` to delete any emptyDir data during draining:
    ```sh
    kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
    ```

- **Mark a node as schedulable/unschedulable:**
  - **Cordon a node**: This prevents the scheduler from placing new pods on the node while allowing existing pods to continue running.
    ```sh
    kubectl cordon <node-name>
    ```
  - **Uncordon a node**: This marks the node as schedulable again, allowing the scheduler to place new pods on it.
    ```sh
    kubectl uncordon <node-name>
    ```

- **Check cluster component statuses:**
  This command gives an overview of the health of various Kubernetes components like the API server, controller manager, and scheduler.
  ```sh
  kubectl get componentstatuses
  ```

### Advanced Commands:

- **Check cluster resource usage:**
  For a quick overview of the cluster's resource usage (memory, CPU, storage):
  ```sh
  kubectl top nodes
  kubectl top pods -n <namespace>
  ```
  This requires the `metrics-server` to be installed in your cluster.

- **View node information:**
  To get detailed information about a node, including its status, labels, and conditions:
  ```sh
  kubectl describe node <node-name>
  ```

- **Check the cluster events:**
  This command provides a timeline of events within the cluster, useful for troubleshooting.
  ```sh
  kubectl get events
  ```

- **View node status with specific conditions:**
  If you want to inspect the conditions (Ready, MemoryPressure, DiskPressure, etc.) of a specific node:
  ```sh
  kubectl describe node <node-name> | grep Conditions
  ```

- **List all pods across namespaces:**
  If you want to see all the pods running across all namespaces in your cluster:
  ```sh
  kubectl get pods --all-namespaces
  ```

- **Get detailed information about a specific pod:**
  To get more in-depth information, including the events and conditions related to a pod:
  ```sh
  kubectl describe pod <pod-name> -n <namespace>
  ```

- **Check control plane health:**
  If you want to monitor the health of the cluster's control plane, you can use the `kubectl get componentstatuses` command. This gives you the status of the API server, scheduler, and controller manager.

- **View detailed API resources:**
  For a deeper view of the available resources and their statuses:
  ```sh
  kubectl explain <resource-type> --recursive
  ```
  This will show detailed documentation for a given resource type, such as `pods` or `services`.

### Complex and Real-World Use Cases:

- **Performing Node Maintenance with Draining:**
  In a production environment, if a node needs maintenance or replacement, you would drain the node, then perform the necessary operations (e.g., software updates or hardware changes), and afterward uncordon the node:
  ```sh
  kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
  ```
  After the node maintenance is complete:
  ```sh
  kubectl uncordon <node-name>
  ```

- **Scale the number of replicas for a deployment across the cluster:**
  If you need to scale a deployment to match available resources or for load balancing, you can adjust the number of replicas in a deployment:
  ```sh
  kubectl scale deployment <deployment-name> --replicas=<number> -n <namespace>
  ```

- **Evict pods from a specific node:**
  To evict all pods from a specific node without draining it:
  ```sh
  kubectl delete pods --all --field-selector spec.nodeName=<node-name>
  ```

- **Perform node upgrades:**
  For managing rolling node upgrades, you would cordon the node to prevent new pods from being scheduled, drain the node to reschedule existing pods, upgrade the node (e.g., using cloud provider tooling), and then uncordon the node:
  1. Cordon the node:
     ```sh
     kubectl cordon <node-name>
     ```
  2. Drain the node:
     ```sh
     kubectl drain <node-name> --ignore-daemonsets
     ```
  3. Upgrade the node via your cloud provider or using other tools (e.g., `kubeadm upgrade` for on-prem clusters).
  4. Uncordon the node:
     ```sh
     kubectl uncordon <node-name>
     ```

- **View and handle resource usage across nodes:**
  If some nodes are under heavy resource utilization, view the node's resource consumption:
  ```sh
  kubectl top nodes
  ```
  Based on the results, you can manually adjust resource limits or scale your workloads to optimize performance across the cluster.

### Troubleshooting Real-World Scenarios:

- **Node is not schedulable due to resource constraints:**
  If a node is under heavy load and no new pods can be scheduled:
  1. Check the node’s available resources:
     ```sh
     kubectl describe node <node-name>
     kubectl top nodes
     ```
  2. If the node is running out of resources, try cordoning the node to prevent new pods from being scheduled:
     ```sh
     kubectl cordon <node-name>
     ```

- **Cluster is unresponsive or slow to respond:**
  If the cluster components are not responding, use the `kubectl get componentstatuses` command to check the health of the control plane.
  ```sh
  kubectl get componentstatuses
  ```
  If any component (e.g., scheduler, controller manager) is not running, investigate further by checking the logs of the control plane components.

- **Pods stuck in `Terminating` state:**
  If pods are stuck in a `Terminating` state, it may indicate issues with resources like volume attachments or network policies:
  1. Investigate pod status:
     ```sh
     kubectl describe pod <pod-name> -n <namespace>
     ```
  2. Force delete the pod if necessary:
     ```sh
     kubectl delete pod <pod-name> -n <namespace> --grace-period=0 --force
     ```

- **Node not showing up as ready or having `NotReady` status:**
  If a node is in a `NotReady` state, inspect its conditions and logs to diagnose why it's not healthy:
  ```sh
  kubectl describe node <node-name>
  ```

### Additional Commands for Cluster Health and Scaling:

- **List all nodes with detailed status:**
  ```sh
  kubectl get nodes -o wide
  ```

- **Check the status of all pods in the cluster (including daemonsets, deployments, etc.):**
  ```sh
  kubectl get pods --all-namespaces -o wide
  ```

- **View and modify resource quotas and limits:**
  Resource quotas ensure that resource usage across the cluster is balanced. To view the current quotas:
  ```sh
  kubectl get resourcequotas -n <namespace>
  ```
  To modify resource quotas:
  ```yaml
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: my-quota
    namespace: <namespace>
  spec:
    hard:
      requests.cpu: "10"
      requests.memory: "32Gi"
      limits.cpu: "20"
      limits.memory: "64Gi"
  ```
