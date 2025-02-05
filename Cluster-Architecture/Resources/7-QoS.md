## **7. Quality of Service (QoS) Classes**  

### **Overview of QoS in Kubernetes**  
Kubernetes assigns a **Quality of Service (QoS) class** to each pod based on its resource requests and limits. These QoS classes help the **kubelet** decide how to prioritize resource allocation, especially when nodes are under high load.  

- Pods with higher QoS classes receive **more stable resource guarantees**.  
- During resource starvation, Kubernetes **evicts lower-priority pods first**.  

Kubernetes defines **three QoS classes**:  
1. **Guaranteed** (Highest Priority)  
2. **Burstable** (Medium Priority)  
3. **BestEffort** (Lowest Priority)  

---

### **1. Guaranteed QoS Class** (Highest Priority)  
A pod is assigned the **Guaranteed** QoS class if:  
- **CPU and memory requests** are **equal** to **limits** for **every container** in the pod.  

**Example Pod Manifest (Guaranteed QoS):**  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-pod
spec:
  containers:
  - name: app-container
    image: my-app:v1
    resources:
      requests:
        cpu: "500m"
        memory: "256Mi"
      limits:
        cpu: "500m"
        memory: "256Mi"
```
- Here, **requests = limits** for both **CPU and memory**, so this pod gets **Guaranteed** QoS.  
- **Guaranteed pods are the last to be evicted** when a node runs out of resources.  

---

### **2. Burstable QoS Class** (Medium Priority)  
A pod falls into the **Burstable** QoS class if:  
- It **has requests defined**, but **limits are higher than requests** OR  
- At least **one container has requests set**, while others do not.  

**Example Pod Manifest (Burstable QoS):**  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: burstable-pod
spec:
  containers:
  - name: app-container
    image: my-app:v1
    resources:
      requests:
        cpu: "200m"
        memory: "128Mi"
      limits:
        cpu: "500m"
        memory: "512Mi"
```
- Here, **requests < limits**, so the pod is **Burstable**.  
- **Pod may be throttled** if it exceeds requests but stays within limits.  
- **Burstable pods are evicted before Guaranteed pods** if the node runs out of resources.  

---

### **3. BestEffort QoS Class** (Lowest Priority)  
A pod gets **BestEffort** QoS if:  
- **No resource requests or limits** are defined for **any container** in the pod.  

**Example Pod Manifest (BestEffort QoS):**  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-pod
spec:
  containers:
  - name: app-container
    image: my-app:v1
    resources: {}  # No requests or limits set
```
- This pod gets the **lowest priority** during resource allocation.  
- If the node is under memory pressure, **BestEffort pods are evicted first**.  
- Useful for **low-priority workloads** that can tolerate disruptions.  

---

### **How Kubernetes Prioritizes QoS During Resource Starvation**  
When a node is under **CPU or memory pressure**, Kubernetes **evicts pods in the following order**:  

1. **BestEffort** pods (first to be evicted).  
2. **Burstable** pods (evicted if their actual usage exceeds requests).  
3. **Guaranteed** pods (evicted last, only if necessary).  

---

### **Key Takeaways**  
- **Guaranteed**: Use for **critical workloads** needing stable performance.  
- **Burstable**: Use when **occasional bursts** of CPU/memory are needed.  
- **BestEffort**: Use for **low-priority tasks** that can tolerate eviction.  
- Kubernetes prioritizes **Guaranteed > Burstable > BestEffort** when deciding which pods to keep under high resource pressure.  