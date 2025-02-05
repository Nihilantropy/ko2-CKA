## **5. Setting Resource Requests and Limits**  

### **Defining Requests and Limits in Pod YAML**  
Kubernetes allows you to define **resource requests** and **limits** within the `resources` field of a container specification in a Pod manifest.  

#### **Example: Setting Requests and Limits in a Pod YAML**  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: my-container
    image: nginx
    resources:
      requests:
        cpu: "250m"  # 250 millicores (0.25 CPU)
        memory: "128Mi"  # 128 MiB of memory
      limits:
        cpu: "500m"  # 500 millicores (0.5 CPU)
        memory: "256Mi"  # 256 MiB of memory
```
**Explanation:**  
- The pod **requests** at least **0.25 CPU** and **128MiB** memory.  
- It **cannot exceed** **0.5 CPU** and **256MiB** memory.  
- If the pod tries to exceed its **CPU limit**, it gets **throttled**.  
- If it exceeds its **memory limit**, it may be **terminated (OOMKilled)**.  

---

### **Applying Requests and Limits to Deployments, StatefulSets, and DaemonSets**  
In real-world applications, resources are typically set at the **controller** level (e.g., Deployments, StatefulSets, DaemonSets) rather than individual pods.  

#### **Example: Setting Requests and Limits in a Deployment**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example-container
        image: my-app
        resources:
          requests:
            cpu: "500m"
            memory: "256Mi"
          limits:
            cpu: "1000m"  # 1 full CPU core
            memory: "512Mi"
```
**Explanation:**  
- This ensures that every replica in the **Deployment** requests a minimum of **0.5 CPU** and **256MiB** of memory.  
- The maximum allowed is **1 CPU** and **512MiB** of memory per pod.  
- The Kubernetes **scheduler** will only place a pod on a node that has at least **0.5 CPU** and **256MiB** memory available.  

---

### **Best Practices for Setting Resource Requests and Limits**  

#### **1. Set Requests Based on Actual Usage**  
- Use **metrics tools** like **Metrics Server**, **Prometheus**, or **kubectl top pods** to monitor resource consumption.  
- Set **requests** slightly higher than the **average** observed usage to avoid unnecessary scheduling delays.  

#### **2. Avoid Overly Restrictive Limits**  
- Setting CPU limits **too low** can cause throttling, reducing application performance.  
- Setting memory limits **too low** can lead to frequent **OOMKilled** pod terminations.  

#### **3. Use LimitRange for Namespace-Level Constraints**  
- A `LimitRange` can enforce **default** requests and limits across a namespace.  
- Example of a `LimitRange` that ensures all pods have at least 100m CPU and 128Mi memory:  
  ```yaml
  apiVersion: v1
  kind: LimitRange
  metadata:
    name: default-limits
    namespace: my-namespace
  spec:
    limits:
    - default:
        cpu: "500m"
        memory: "256Mi"
      defaultRequest:
        cpu: "100m"
        memory: "128Mi"
      type: Container
  ```
  
#### **4. Consider QoS Classes for Guaranteed Performance**  
- Kubernetes assigns **Quality of Service (QoS) classes** based on requests and limits:  
  - **Guaranteed**: Requests = Limits (best for critical workloads).  
  - **Burstable**: Requests < Limits (default behavior for most apps).  
  - **BestEffort**: No requests or limits set (lowest priority).  
- Critical workloads should be **Guaranteed** or **Burstable** to ensure availability.  

#### **5. Regularly Adjust Based on Workload Needs**  
- Resource requirements **change over time**.  
- Periodically review pod usage and **adjust requests and limits** accordingly.  

---

### **Key Takeaways**  
- **Requests define minimum required resources**, while **limits cap the maximum usage**.  
- **Set requests based on actual usage** to avoid inefficient scheduling.  
- **Be cautious with limits** to prevent throttling and unexpected pod termination.  
- **Use LimitRanges and QoS classes** to enforce resource policies.  
- **Continuously monitor and adjust** to optimize resource efficiency.