## **3. Understanding Resource Limits**  

### **What Are Resource Limits?**  
Resource **limits** in Kubernetes define the **maximum** amount of **CPU** and **memory (RAM)** that a container can use. If a container tries to exceed these limits:  

- **For CPU:** Kubernetes throttles the CPU usage, slowing down the container.  
- **For Memory:** If a container exceeds the memory limit, it gets **terminated (OOMKilled)** by Kubernetes.  

Limits ensure that no single pod consumes excessive resources, preventing cluster instability.  

### **How Resource Limits Affect Pod Execution**  
1. **CPU Limits:**  
   - If a container reaches its CPU limit, Kubernetes **throttles** it, reducing processing speed but keeping the container running.  
   - Unlike memory, exceeding the CPU limit does not cause the container to be killed.  

2. **Memory Limits:**  
   - If a container tries to use more memory than its limit, the system **kills the container** (Out of Memory - OOMKilled).  
   - The pod may restart if it has a **restart policy** like `Always`.  

3. **Impact on Cluster Stability:**  
   - Without limits, a misbehaving pod could consume all node resources, causing performance degradation for other workloads.  
   - Setting appropriate limits ensures fair resource distribution across multiple applications.  

### **CPU Throttling and Memory OOM (Out of Memory) Scenarios**  
#### **CPU Throttling:**  
- If a container requests **500m CPU** but has a limit of **1 CPU**, it can burst up to **1 CPU** when available.  
- If CPU usage reaches the limit, Kubernetes **throttles** the container, reducing execution speed.  

#### **Memory OOM (Out of Memory) Scenario:**  
- If a container requests **512Mi memory** but has a limit of **1Gi**, it can use up to **1Gi**.  
- If the container tries to use more than **1Gi**, the **OOM Killer** terminates it.  

### **Example of Resource Limits in a Pod Manifest**  
Resource limits are defined under `resources.limits` in a **pod specification**:  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-limits-example
spec:
  containers:
    - name: app-container
      image: nginx
      resources:
        limits:
          cpu: "1"  # Maximum 1 CPU core
          memory: "1Gi"  # Maximum 1 GiB of RAM
      ports:
        - containerPort: 80
```

### **Key Takeaways:**  
- **Limits define the maximum CPU and memory a container can use.**  
- **Exceeding CPU limits leads to throttling, while exceeding memory limits causes termination.**  
- **Setting proper limits prevents resource monopolization and ensures cluster stability.**