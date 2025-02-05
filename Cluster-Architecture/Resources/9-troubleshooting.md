## **9. Troubleshooting Resource Requests and Limits Issues**  

When setting resource requests and limits in Kubernetes, misconfigurations can lead to scheduling failures, performance degradation, and pod terminations. This section covers common issues and how to diagnose and resolve them.  

---

### **Debugging Pods Stuck in Pending Due to Insufficient Resources**  
A pod may remain in the **Pending** state if the Kubernetes scheduler cannot find a node that meets the requested CPU and memory requirements.  

#### **Common Causes:**  
- **Node resource exhaustion**: No node has enough available CPU or memory.  
- **Overly strict requests**: Requested resources are too high for any available node.  
- **ResourceQuota exceeded**: Namespace resource limits prevent the pod from starting.  

#### **How to Diagnose:**  
Use `kubectl describe pod <pod-name>` to check the **Events** section for scheduling issues:  
```sh
kubectl describe pod my-app-pod
```
Example output:  
```
Events:
  Type     Reason    Age   From               Message
  ----     ------    ----  ----               -------
  Warning  FailedScheduling  10s   default-scheduler  0/5 nodes are available: 
  3 Insufficient memory, 2 Insufficient CPU.
```
  
#### **Resolution:**  
- Reduce **CPU and memory requests** in the pod specification.  
- Ensure cluster nodes have sufficient capacity.  
- Check if **ResourceQuota** is limiting the pod:  
  ```sh
  kubectl get resourcequota -n my-namespace
  ```
- Scale the cluster by adding more nodes if necessary.  

---

### **Diagnosing OOMKilled and CPU Throttling Issues**  
Pods can crash or experience degraded performance due to **memory overuse (OOMKilled) or CPU throttling**.  

#### **OOMKilled (Out of Memory Killed)**  
If a pod exceeds its **memory limit**, the **OOM (Out of Memory) Killer** will terminate it.  
##### **How to Detect OOMKilled:**
Check pod status using:  
```sh
kubectl get pod my-app-pod -o wide
```
If a pod has been **terminated due to OOM**, describe the pod:  
```sh
kubectl describe pod my-app-pod
```
Example output:  
```
State:       Terminated
  Reason:    OOMKilled
  Exit Code: 137
```
##### **Resolution for OOMKilled:**  
- **Increase memory limits** in the pod spec.  
- Optimize application memory usage.  
- Use monitoring tools like **Prometheus** to track memory consumption trends.  

---

#### **CPU Throttling Issues**  
When a pod reaches its **CPU limit**, Kubernetes throttles the CPU, causing performance degradation.  

##### **How to Detect CPU Throttling:**  
Use the following command to inspect CPU usage:  
```sh
kubectl top pod my-app-pod
```
If a pod consistently hits its **CPU limit**, check for throttling in **container metrics** using Prometheus or Grafana.  

##### **Resolution for CPU Throttling:**  
- **Increase CPU limits** if the application needs more processing power.  
- Use **CPU requests** effectively to ensure fair scheduling.  
- Optimize the application's CPU usage to prevent excessive throttling.  

---

### **Using `kubectl describe pod` to Analyze Resource Allocation**  
To get detailed resource allocation and troubleshooting information, use:  
```sh
kubectl describe pod my-app-pod
```
#### **Key Sections to Review:**  
- **Requests and Limits:**  
  ```
  Limits:
    cpu: 500m
    memory: 256Mi
  Requests:
    cpu: 200m
    memory: 128Mi
  ```
- **Events:** Shows scheduling failures, OOM errors, and other issues.  
- **State:** Indicates if a container is running, terminated, or crashed.  

By carefully setting **resource requests and limits** and using these **debugging techniques**, you can ensure stable performance and prevent resource-related failures in Kubernetes clusters.