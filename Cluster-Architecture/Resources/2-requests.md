## **2. Understanding Resource Requests**  

### **What Are Resource Requests?**  
Resource **requests** in Kubernetes define the minimum amount of **CPU** and **memory (RAM)** that a container needs to run properly. When a pod is scheduled, the Kubernetes scheduler ensures that the node it is assigned to has at least the requested amount of resources available.  

- **CPU Requests**: Measured in CPU cores (e.g., `0.5` for half a core or `500m` for 500 millicores).  
- **Memory Requests**: Measured in bytes (e.g., `512Mi` for 512 mebibytes or `1Gi` for 1 gibibyte).  

If no node in the cluster has enough free resources to meet the request, the pod remains in a **Pending** state until resources become available.  

### **How Resource Requests Affect Pod Scheduling**  
The Kubernetes scheduler considers **resource requests** when assigning a pod to a node:  

1. **Ensuring Available Resources**:  
   - The scheduler looks for a node with enough **free CPU and memory** to satisfy the requested resources.  
   - If no suitable node is found, the pod remains **Pending**.  

2. **Fair Distribution of Resources**:  
   - Kubernetes uses requests to ensure fair resource allocation among multiple workloads.  
   - Prevents one pod from consuming all available CPU/memory on a node.  

3. **Influence on Quality of Service (QoS) Classes**:  
   - Pods with defined requests are assigned a **Burstable** or **Guaranteed QoS** class, making them less likely to be evicted under resource pressure.  

### **Specifying CPU and Memory Requests in Pod Specifications**  
Resource requests are specified under the `resources.requests` field in a pod's **container specification**.  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
    - name: app-container
      image: my-app:latest
      resources:
        requests:
          cpu: "250m"  # 250 millicores (0.25 vCPU)
          memory: "256Mi"  # 256 MiB of RAM
```

### **Example of Resource Requests in a Pod Manifest**  
Here’s a complete example of a **pod manifest** that defines resource requests:  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-requests-example
spec:
  containers:
    - name: app-container
      image: nginx
      resources:
        requests:
          cpu: "500m"  # 0.5 CPU core
          memory: "512Mi"  # 512 MiB of RAM
      ports:
        - containerPort: 80
```

### **Key Takeaways:**  
- **Requests define the minimum resources** Kubernetes guarantees to a pod.  
- **Pods won’t be scheduled unless a node has enough requested resources available.**  
- **Proper resource requests prevent resource starvation and improve cluster stability.**