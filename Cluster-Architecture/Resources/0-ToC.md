## **Table of Contents**  

### **1. Introduction to Resource Requests and Limits**  
   - Definition and Purpose of Resource Requests and Limits  
   - Importance of Resource Management in Kubernetes  
   - How Kubernetes Schedules Pods Based on Resource Requests  

### **2. Understanding Resource Requests**  
   - What Are Resource Requests?  
   - How Resource Requests Affect Pod Scheduling  
   - Specifying CPU and Memory Requests in Pod Specifications  
   - Example of Resource Requests in a Pod Manifest  

### **3. Understanding Resource Limits**  
   - What Are Resource Limits?  
   - How Resource Limits Affect Pod Execution  
   - CPU Throttling and Memory OOM (Out of Memory) Scenarios  
   - Example of Resource Limits in a Pod Manifest  

### **4. How Kubernetes Manages Resources**  
   - Role of the Scheduler in Resource Allocation  
   - Resource Requests vs. Limits: Key Differences  
   - Impact of Over-Provisioning and Under-Provisioning  
   - Resource Allocation in Multi-Tenant Clusters  

### **5. Setting Resource Requests and Limits**  
   - Defining Requests and Limits in Pod YAML  
   - Applying Requests and Limits to Deployments, StatefulSets, and DaemonSets  
   - Best Practices for Setting Resource Requests and Limits  

### **6. Monitoring and Adjusting Resource Usage**  
   - Tools for Monitoring Resource Consumption  
     - `kubectl top pod`  
     - Kubernetes Metrics Server  
     - Prometheus and Grafana  
   - Adjusting Requests and Limits Based on Observed Usage  

### **7. Quality of Service (QoS) Classes**  
   - Overview of QoS in Kubernetes  
   - **Guaranteed QoS Class**: When Requests = Limits  
   - **Burstable QoS Class**: Requests < Limits  
   - **BestEffort QoS Class**: No Requests or Limits Set  
   - How Kubernetes Prioritizes QoS During Resource Starvation  

### **8. Resource Requests and Limits in Namespaces**  
   - Enforcing Default Requests and Limits with LimitRange  
   - Setting Resource Quotas at the Namespace Level  
   - Preventing Resource Exhaustion in Shared Clusters  

### **9. Troubleshooting Resource Requests and Limits Issues**  
   - Debugging Pods Stuck in Pending Due to Insufficient Resources  
   - Diagnosing OOMKilled and CPU Throttling Issues  
   - Using `kubectl describe pod` to Analyze Resource Allocation  

### **10. Best Practices for Managing Resources**  
   - Choosing Optimal Resource Requests and Limits  
   - Avoiding Overcommitment and Underutilization  
   - Periodic Resource Audits and Auto-Scaling Considerations  

### **11. Conclusion**  
   - Summary of Key Concepts  
   - Ensuring Efficient Resource Utilization in Kubernetes  
   - Final Thoughts on Optimizing Resource Requests and Limits  
