## **4. Deleting Resources**

### **4.1. Deleting Specific Resources**
- **Delete a specific pod:**  
  ```sh
  kubectl delete pod <pod-name>
  ```
  *(Useful when a pod is stuck in a CrashLoopBackOff state and needs recreation.)*  
- **Delete a specific deployment:**  
  ```sh
  kubectl delete deployment <deployment-name>
  ```
- **Delete a service:**  
  ```sh
  kubectl delete service <service-name>
  ```
- **Delete a Persistent Volume Claim (PVC) and Persistent Volume (PV) together:**  
  ```sh
  kubectl delete pvc <pvc-name>
  kubectl delete pv <pv-name>
  ```
  *(Ensure that the storage is properly deallocated before deleting the PV.)*

---

### **4.2. Deleting Resources Using YAML Definitions**
- **Delete resources defined in a YAML file:**  
  ```sh
  kubectl delete -f <file>.yaml
  ```
- **Delete multiple resources from multiple YAML files at once:**  
  ```sh
  kubectl delete -f <file1>.yaml -f <file2>.yaml
  ```
- **Delete resources matching a specific label selector:**  
  ```sh
  kubectl delete pods -l app=nginx
  ```
  *(Deletes all pods that have the label `app=nginx`.)*
- **Delete a resource only if it exists (avoiding errors if it doesn't):**  
  ```sh
  kubectl get pod <pod-name> && kubectl delete pod <pod-name>
  ```

---

### **4.3. Bulk Deletion of Resources**
- **Delete all pods in a specific namespace:**  
  ```sh
  kubectl delete pods --all -n <namespace>
  ```
- **Delete all deployments in a namespace:**  
  ```sh
  kubectl delete deployments --all -n <namespace>
  ```
- **Delete all resources of a specific type across all namespaces:**  
  ```sh
  kubectl delete pods --all --all-namespaces
  ```
- **Delete all resources of multiple types (e.g., pods, services, deployments) at once:**  
  ```sh
  kubectl delete pods,services,deployments --all
  ```

---

### **4.4. Forcing Deletion in Stuck or Terminating States**
- **Force delete a pod that is stuck in a terminating state:**  
  ```sh
  kubectl delete pod <pod-name> --grace-period=0 --force
  ```
  *(This immediately removes a stuck pod instead of waiting for it to terminate gracefully.)*  
- **Force delete all pods in a namespace without waiting for graceful termination:**  
  ```sh
  kubectl delete pods --all -n <namespace> --grace-period=0 --force
  ```
- **Manually delete a pod from etcd if `kubectl delete` does not work:**  
  ```sh
  kubectl get pod <pod-name> -o json | kubectl delete -f -
  ```
  *(Useful when the API server does not delete a pod correctly.)*

---

### **4.5. Cleaning Up Entire Environments**
- **Delete all resources in a namespace:**  
  ```sh
  kubectl delete all --all -n <namespace>
  ```
  *(This removes all pods, services, deployments, and other resources in the namespace.)*  
- **Delete a namespace and all resources inside it:**  
  ```sh
  kubectl delete namespace <namespace>
  ```
- **Delete all completed jobs (batch workloads that have finished running):**  
  ```sh
  kubectl delete jobs --field-selector=status.successful=1
  ```
- **Delete an entire Kubernetes cluster (for Minikube users):**  
  ```sh
  minikube delete
  ```
  *(This completely removes the Minikube cluster, useful for fresh setups.)*

---

### **4.6. Troubleshooting Deletion Issues**
- **Check if a resource is stuck in deletion (`Terminating` state):**  
  ```sh
  kubectl get pod <pod-name> -o jsonpath='{.metadata.deletionTimestamp}'
  ```
- **Manually remove the finalizer on a stuck resource to force deletion:**  
  ```sh
  kubectl patch pod <pod-name> -p '{"metadata":{"finalizers":null}}'
  ```
  *(Some resources may not delete due to finalizers preventing it.)*  
- **Check for dependencies before deleting (useful when services depend on pods):**  
  ```sh
  kubectl get svc -o json | jq '.items[] | select(.spec.selector.app=="my-app")'
  ```
  *(Ensures no running services still depend on the pod or deployment.)*

---

### **4.7. Real-World Scenarios**
🔹 **Scenario 1: Removing failed pods quickly**  
```sh
kubectl delete pod -l status.phase=Failed
```
*(Deletes all pods that have failed and won’t recover.)*  

🔹 **Scenario 2: Deleting old pods while keeping the newest 3**  
```sh
kubectl get pods --sort-by=.metadata.creationTimestamp | head -n -3 | awk '{print $1}' | xargs kubectl delete pod
```
*(Useful for cleaning up old pods but keeping recent ones.)*  

🔹 **Scenario 3: Deleting all Evicted pods (caused by resource constraints)**  
```sh
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod
```
*(Helps free up cluster resources when nodes evict pods due to memory/CPU limits.)*  

🔹 **Scenario 4: Deleting all pods on a specific node (draining a node for maintenance)**  
```sh
kubectl delete pod --field-selector spec.nodeName=<node-name>
```
*(Useful when taking down a node for maintenance.)*  

🔹 **Scenario 5: Cleaning up orphaned persistent volumes that were dynamically provisioned**  
```sh
kubectl get pv --field-selector=status.phase=Released -o json | jq -r '.items[].metadata.name' | xargs kubectl delete pv
```
*(Deletes volumes that were unbound from PVCs but still exist in the cluster.)*  
