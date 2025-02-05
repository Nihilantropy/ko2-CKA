## **6. Monitoring and Adjusting Resource Usage**  

### **Tools for Monitoring Resource Consumption**  
To ensure efficient resource utilization, Kubernetes provides various tools to monitor pod and container-level resource consumption.  

#### **1. `kubectl top pod` (Basic CLI Monitoring)**  
The `kubectl top pod` command provides a quick way to check the CPU and memory usage of running pods.  

```sh
kubectl top pod --namespace=my-namespace
```
**Example Output:**  
```
NAME         CPU(cores)   MEMORY(bytes)  
app-pod-1   200m         150Mi  
app-pod-2   300m         180Mi  
app-pod-3   100m         120Mi  
```
**Key Insights:**  
- Helps quickly spot pods consuming **excessive** or **insufficient** resources.  
- Useful for debugging **resource throttling** or **OOMKilled** events.  

#### **2. Kubernetes Metrics Server (Real-Time Metrics API)**  
- The **Metrics Server** provides real-time CPU and memory usage.  
- It is required for `kubectl top pod` and **Horizontal Pod Autoscaler (HPA)**.  
- Install it if not already running:  
  ```sh
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```
- Verify installation:  
  ```sh
  kubectl get apiservice v1beta1.metrics.k8s.io
  ```

#### **3. Prometheus and Grafana (Advanced Monitoring & Visualization)**  
- **Prometheus** collects and stores Kubernetes resource metrics.  
- **Grafana** provides dashboards for visualizing CPU/memory usage trends.  
- Example query to check pod CPU usage in Prometheus:  
  ```sh
  sum(rate(container_cpu_usage_seconds_total{namespace="my-namespace"}[5m])) by (pod)
  ```
- **Grafana Dashboards** help:  
  - Detect **CPU throttling**.  
  - Monitor **OOM kills** due to memory exhaustion.  
  - Analyze **long-term resource trends**.  

---

### **Adjusting Requests and Limits Based on Observed Usage**  

#### **Step 1: Identify Underutilized or Overutilized Pods**  
- If a pod **consistently uses much less than its requests**, it may be over-provisioned.  
- If a pod **regularly exceeds its limits**, it may need more resources.  
- Use Prometheus or `kubectl top pod` to check CPU/memory patterns.  

#### **Step 2: Update Pod Resource Requests and Limits**  
- Modify the Deployment or StatefulSet YAML based on actual usage trends.  
- Example: If a container is using only **100m CPU but requests 500m**, adjust it:  
  ```yaml
  resources:
    requests:
      cpu: "150m"  # Adjusted from 500m to 150m
      memory: "200Mi"
    limits:
      cpu: "400m"  # Adjusted limit based on peak usage
      memory: "400Mi"
  ```
- Apply the updated configuration:  
  ```sh
  kubectl apply -f deployment.yaml
  ```

#### **Step 3: Test and Monitor Changes**  
- After adjusting requests and limits, monitor pod performance.  
- Check for **scheduling issues** (if requests are too high) or **performance problems** (if limits are too low).  
- Continuously refine based on observed trends.  

---

### **Key Takeaways**  
- **Use `kubectl top pod` and Metrics Server** for quick resource checks.  
- **Leverage Prometheus and Grafana** for in-depth monitoring.  
- **Adjust requests and limits** based on actual pod usage to optimize cluster efficiency.  
- **Continuously refine resource settings** to balance cost, performance, and availability.