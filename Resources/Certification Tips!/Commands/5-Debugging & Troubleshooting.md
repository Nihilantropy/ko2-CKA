## **5. Debugging and Troubleshooting**  

### **5.1. Viewing Logs**  
- **View logs from a pod:**  
  ```sh
  kubectl logs <pod-name>
  ```
  *(Useful for checking application errors inside a pod.)*  

- **View logs from a specific container inside a multi-container pod:**  
  ```sh
  kubectl logs <pod-name> -c <container-name>
  ```
  *(Helpful when a pod has multiple containers, and you need logs for a specific one.)*  

- **Stream live logs from a running pod:**  
  ```sh
  kubectl logs -f <pod-name>
  ```
  *(Useful for real-time debugging of long-running applications.)*  

- **View logs for a previously terminated pod:**  
  ```sh
  kubectl logs --previous <pod-name>
  ```
  *(Helpful if a pod crashed and restarted, and you need logs from before the restart.)*  

- **Get logs from multiple pods at once (useful in deployments):**  
  ```sh
  kubectl logs -l app=<label> --all-containers
  ```
  *(Collects logs from all pods with the same label, useful for debugging distributed applications.)*  

---

### **5.2. Debugging Pods and Containers**  
- **Execute commands inside a running container (interactive shell):**  
  ```sh
  kubectl exec -it <pod-name> -- /bin/sh
  ```
  *(Opens a shell inside the container, useful when debugging containerized applications.)*  

- **For containers using Bash instead of SH:**  
  ```sh
  kubectl exec -it <pod-name> -- /bin/bash
  ```

- **Run a single command inside a container:**  
  ```sh
  kubectl exec <pod-name> -- ls /app
  ```
  *(Executes the `ls` command inside the container, useful for checking files inside a containerized app.)*  

- **Start a temporary debugging pod in case the main pod lacks a shell:**  
  ```sh
  kubectl run debug-pod --rm -it --image=busybox -- /bin/sh
  ```
  *(If your container doesn’t have a shell, use this temporary pod to investigate issues in the cluster.)*  

- **Copy files from a pod to your local machine (debugging file-related issues):**  
  ```sh
  kubectl cp <pod-name>:/path/to/file /local/path
  ```

---

### **5.3. Checking Cluster Events and Status**  
- **View recent events in the cluster (sorted by time):**  
  ```sh
  kubectl get events --sort-by='.metadata.creationTimestamp'
  ```
  *(Useful for identifying issues like pod failures, scheduling errors, or node crashes.)*  

- **Describe a pod to see why it’s failing:**  
  ```sh
  kubectl describe pod <pod-name>
  ```
  *(Shows detailed information, including errors, restarts, and scheduling issues.)*  

- **Check why a pod is stuck in `Pending` state:**  
  ```sh
  kubectl get pod <pod-name> -o jsonpath='{.status.conditions}'
  ```
  *(Identifies whether it’s due to insufficient resources, scheduling issues, or other reasons.)*  

- **Check which node a pod is running on:**  
  ```sh
  kubectl get pod <pod-name> -o wide
  ```
  *(Useful for debugging node-specific failures.)*  

---

### **5.4. Monitoring Resource Utilization**  
- **Show real-time CPU and memory usage by pods:**  
  ```sh
  kubectl top pod
  ```
  *(Helps diagnose performance issues and resource limits.)*  

- **Show real-time CPU and memory usage by nodes:**  
  ```sh
  kubectl top node
  ```
  *(Useful for detecting which nodes are under high load.)*  

- **List pods that are consuming the most memory:**  
  ```sh
  kubectl top pod --sort-by=memory
  ```
  *(Quickly identify memory-hungry workloads.)*  

- **Check resource requests and limits for a pod:**  
  ```sh
  kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].resources}'
  ```
  *(Ensures that a pod is running within its assigned CPU/memory limits.)*  

---

### **5.5. Debugging Networking Issues**  
- **Check network policies affecting a pod:**  
  ```sh
  kubectl get networkpolicy -o wide
  ```
  *(Determines if network policies are blocking traffic to/from a pod.)*  

- **Check if a pod can reach another service (inside the cluster):**  
  ```sh
  kubectl run curlpod --rm -it --image=curlimages/curl -- curl http://<service-name>:<port>
  ```
  *(Verifies if a pod can access a service over the cluster network.)*  

- **Check DNS resolution inside a pod:**  
  ```sh
  kubectl exec -it <pod-name> -- nslookup <service-name>
  ```
  *(Ensures that DNS is properly resolving service names.)*  

- **Get detailed networking information about a pod:**  
  ```sh
  kubectl get pod <pod-name> -o jsonpath='{.status.podIP}'
  ```
  *(Useful for debugging pod-to-pod communication issues.)*  

---

### **5.6. Debugging Node Issues**  
- **List all nodes and their statuses:**  
  ```sh
  kubectl get nodes -o wide
  ```
  *(Identifies which nodes are `Ready` or `NotReady`.)*  

- **Describe a node to check for resource constraints:**  
  ```sh
  kubectl describe node <node-name>
  ```
  *(Shows CPU, memory, and disk pressure warnings.)*  

- **Check disk space usage on a node:**  
  ```sh
  ssh <node-ip> "df -h"
  ```
  *(Useful if a node is running out of disk space and causing pod failures.)*  

---

### **5.7. Debugging Stuck or Failed Pods**  
- **Identify pods stuck in a `CrashLoopBackOff` state:**  
  ```sh
  kubectl get pods --field-selector=status.phase=Failed
  ```
  *(Lists only failed pods, useful for quickly pinpointing issues.)*  

- **Manually restart a failed pod:**  
  ```sh
  kubectl delete pod <pod-name>
  ```
  *(Triggers Kubernetes to recreate the pod from the deployment or replica set.)*  

- **Check detailed status of a pod stuck in `ContainerCreating`:**  
  ```sh
  kubectl describe pod <pod-name>
  ```
  *(Looks for issues like missing images, insufficient resources, or networking errors.)*  

- **Force restart all pods in a deployment (if pods are stuck or unresponsive):**  
  ```sh
  kubectl rollout restart deployment <deployment-name>
  ```
  *(Gracefully restarts all pods in a deployment.)*  

---

### **5.8. Real-World Scenarios**
🔹 **Scenario 1: Pod is crashing due to insufficient memory**  
```sh
kubectl describe pod <pod-name> | grep -i oom
```
*(Finds out if a pod was killed due to an Out of Memory (OOM) error.)*  

🔹 **Scenario 2: Debugging a stuck pod that never starts**  
```sh
kubectl get events --sort-by='.lastTimestamp' | grep <pod-name>
```
*(Checks for scheduling or node-related failures.)*  

🔹 **Scenario 3: Checking why a pod can't pull an image**  
```sh
kubectl describe pod <pod-name> | grep -i ImagePullBackOff
```
*(Finds out if there's an authentication or missing image issue.)*  

🔹 **Scenario 4: Verifying if a service is reachable**  
```sh
kubectl exec -it <pod-name> -- curl -v http://<service-name>:<port>
```
*(Checks if networking is properly configured.)*  
