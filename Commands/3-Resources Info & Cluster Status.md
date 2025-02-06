## **3. Viewing Resources and Cluster Status**

### **3.1. Listing Resources**
- **List multiple resources at once (pods, services, deployments, nodes):**  
  ```sh
  kubectl get pods,services,deployments,nodes
  ```
- **List all available resources in the cluster:**  
  ```sh
  kubectl get all
  ```
- **List all resources across all namespaces:**  
  ```sh
  kubectl get all --all-namespaces
  ```
- **List all pods with additional details (wide output):**  
  ```sh
  kubectl get pods -o wide
  ```
- **List all pods sorted by restart count (useful for detecting failing pods):**  
  ```sh
  kubectl get pods --sort-by=.status.containerStatuses[0].restartCount
  ```
- **List all pods in a specific namespace:**  
  ```sh
  kubectl get pods -n <namespace>
  ```
- **List only pod names (useful for scripting):**  
  ```sh
  kubectl get pods -o custom-columns=:metadata.name
  ```

---

### **3.2. Describing and Inspecting Resources**
- **Describe details of a specific resource (e.g., pod, deployment, node, service):**  
  ```sh
  kubectl describe <resource> <name>
  ```
- **Describe a pod to check its events and container details:**  
  ```sh
  kubectl describe pod <pod-name>
  ```
- **Describe a node to inspect resource allocation and conditions:**  
  ```sh
  kubectl describe node <node-name>
  ```
- **Describe a deployment to check strategy, replicas, and status:**  
  ```sh
  kubectl describe deployment <deployment-name>
  ```

---

### **3.3. Checking Cluster and API Resources**
- **Get cluster-wide information:**  
  ```sh
  kubectl cluster-info
  ```
- **View API resources available in the cluster (with short names and API versions):**  
  ```sh
  kubectl api-resources
  ```
- **View API versions supported by the cluster:**  
  ```sh
  kubectl api-versions
  ```
- **List available API groups and their versions (for compatibility checks):**  
  ```sh
  kubectl get --raw /apis | jq '.groups[].name'
  ```
- **Get detailed information about the control plane components:**  
  ```sh
  kubectl get componentstatuses
  ```

---

### **3.4. Viewing Resource Utilization**
- **Check resource utilization of nodes:**  
  ```sh
  kubectl top node
  ```
- **Check resource utilization of pods:**  
  ```sh
  kubectl top pod
  ```
- **Check resource utilization of a specific pod in a namespace:**  
  ```sh
  kubectl top pod <pod-name> -n <namespace>
  ```

---

### **3.5. Events, Logs, and Troubleshooting**
- **List recent events in the cluster (sorted by timestamp):**  
  ```sh
  kubectl get events --sort-by=.metadata.creationTimestamp
  ```
- **Get events for a specific namespace:**  
  ```sh
  kubectl get events -n <namespace>
  ```
- **View logs from a specific pod’s container:**  
  ```sh
  kubectl logs <pod-name> -c <container-name>
  ```
- **Stream logs from a running container in real time:**  
  ```sh
  kubectl logs -f <pod-name>
  ```
- **Check the status of a rollout (for deployments):**  
  ```sh
  kubectl rollout status deployment/<deployment-name>
  ```
- **Check if a pod is pending and why:**  
  ```sh
  kubectl get pod <pod-name> -o jsonpath='{.status.conditions}'
  ```
- **Debug a running pod by starting an interactive shell session:**  
  ```sh
  kubectl exec -it <pod-name> -- /bin/sh
  ```
  *(For Alpine-based images, use `/bin/sh`. For Debian/Ubuntu-based images, use `/bin/bash`.)*

---

### **3.6. Advanced Queries**
- **Find all pods using a specific image:**  
  ```sh
  kubectl get pods -A -o json | jq -r '.items[] | select(.spec.containers[].image | contains("<image-name>")) | .metadata.name'
  ```
- **Find all nodes that are ready:**  
  ```sh
  kubectl get nodes --field-selector=status.phase=Running
  ```
- **Find all pods in a failed state:**  
  ```sh
  kubectl get pods --field-selector=status.phase=Failed
  ```
- **Find all pods with a specific label (e.g., `app=nginx`):**  
  ```sh
  kubectl get pods -l app=nginx
  ```
- **List services of type LoadBalancer only:**  
  ```sh
  kubectl get svc --field-selector=spec.type=LoadBalancer
  ```

---

### **3.7. Checking Storage and Networking**
- **View Persistent Volumes (PVs) and Persistent Volume Claims (PVCs):**  
  ```sh
  kubectl get pv,pvc
  ```
- **Check details of a Persistent Volume Claim (useful for troubleshooting storage issues):**  
  ```sh
  kubectl describe pvc <pvc-name>
  ```
- **List all services and their external IPs:**  
  ```sh
  kubectl get svc -o wide
  ```
- **Check endpoints for a service to verify which pods are backing it:**  
  ```sh
  kubectl get endpoints <service-name>
  ```
- **Check network policies applied in a namespace:**  
  ```sh
  kubectl get networkpolicies -n <namespace>
  ```
