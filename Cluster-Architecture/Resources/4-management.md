## **4. How Kubernetes Manages Resources**  

### **Role of the Scheduler in Resource Allocation**  
The Kubernetes **scheduler** is responsible for assigning pods to nodes based on available resources. It considers:  
- **Resource Requests**: Ensures the node has enough CPU and memory to meet the pod’s requirements.  
- **Resource Limits**: Helps in preventing a single pod from consuming excessive resources.  
- **Node Capacity**: The scheduler avoids placing pods on nodes that are already at full capacity.  
- **Affinity, Taints, and Tolerations**: The scheduler also considers affinity rules and node taints when placing pods.  

If a node does not have enough available resources to satisfy a pod’s **requests**, the pod remains in a `Pending` state until resources free up or another suitable node becomes available.  

### **Resource Requests vs. Limits: Key Differences**  
| Feature           | Resource Requests | Resource Limits |
|------------------|-----------------|----------------|
| **Definition**    | The minimum guaranteed CPU & memory required by a pod. | The maximum CPU & memory a pod can use. |
| **Impact on Scheduling** | Affects **where** the pod is placed; the scheduler ensures enough resources are available. | Does not affect initial scheduling but restricts how much a pod can consume at runtime. |
| **CPU Behavior**  | Ensures a pod gets at least the requested CPU share. | If CPU usage exceeds the limit, the container is **throttled**. |
| **Memory Behavior** | Ensures a pod gets at least the requested memory. | If memory usage exceeds the limit, the container is **killed (OOMKilled)**. |

### **Impact of Over-Provisioning and Under-Provisioning**  

- **Over-Provisioning (Setting Requests Too High)**  
  - Causes inefficient resource utilization.  
  - Some nodes may appear full even though they have available resources.  
  - Leads to unnecessary pod scheduling delays.  

- **Under-Provisioning (Setting Requests Too Low)**  
  - Increases the risk of resource contention, where multiple pods compete for CPU and memory.  
  - Can cause unexpected throttling or pod crashes if a pod exceeds available resources.  

- **Over-Provisioning Limits**  
  - If CPU and memory **limits** are set too high, a single pod might consume excessive resources, affecting other workloads.  

- **Under-Provisioning Limits**  
  - If **limits** are set too low, pods may get terminated (OOMKilled) even if the node has enough capacity.  

### **Resource Allocation in Multi-Tenant Clusters**  
In **multi-tenant Kubernetes clusters** (where multiple teams or applications share resources), careful resource management is crucial to ensure fair usage:  

- **Namespaces and Resource Quotas:**  
  - Kubernetes allows defining **resource quotas** at the namespace level to prevent teams from over-consuming resources.  

- **Limit Ranges:**  
  - `LimitRange` policies ensure that all pods have appropriate request and limit values, preventing misconfigurations.  

- **Node Affinity and Taints:**  
  - Assign workloads to specific nodes using **node affinity** and **taints/tolerations** to isolate critical applications.  

### **Key Takeaways:**  
- The Kubernetes **scheduler** assigns pods based on **requests**, ensuring sufficient resources are available.  
- **Requests affect scheduling**, while **limits control runtime resource consumption**.  
- **Over-provisioning wastes resources**, and **under-provisioning can cause instability**.  
- **Multi-tenant clusters require quotas and policies** to ensure fair resource distribution.