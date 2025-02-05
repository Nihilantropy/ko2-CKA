## **8. Resource Requests and Limits in Namespaces**  

### **Enforcing Default Requests and Limits with LimitRange**  
In Kubernetes, administrators can enforce **default resource requests and limits** for a namespace using the **LimitRange** resource. This ensures that all pods within a namespace have at least a minimum request and do not exceed a maximum limit.  

**Key Benefits of LimitRange:**  
- Prevents pods from **overusing cluster resources**.  
- Ensures that workloads get **a fair share of resources**.  
- Helps **avoid scheduling issues** caused by missing resource requests.  

**Example LimitRange Manifest:**  
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: my-namespace
spec:
  limits:
  - type: Container
    default:
      cpu: "500m"
      memory: "256Mi"
    defaultRequest:
      cpu: "200m"
      memory: "128Mi"
    max:
      cpu: "2"
      memory: "2Gi"
    min:
      cpu: "100m"
      memory: "64Mi"
```
- **default**: Sets a default CPU and memory limit if a pod doesn’t specify one.  
- **defaultRequest**: Assigns a default resource request if not explicitly defined.  
- **max / min**: Restricts the allowed range for resource requests and limits.  

---

### **Setting Resource Quotas at the Namespace Level**  
To **control the total resource usage** in a namespace, Kubernetes provides the **ResourceQuota** object. This prevents excessive resource consumption by limiting the **total CPU, memory, and number of pods** that can be created in a namespace.  

**Key Benefits of ResourceQuota:**  
- Ensures **fair resource distribution** across multiple teams.  
- Prevents a single namespace from **consuming all cluster resources**.  
- Enforces **limits on total resource usage** within a namespace.  

**Example ResourceQuota Manifest:**  
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: my-namespace
spec:
  hard:
    requests.cpu: "4"        # Total CPU requests cannot exceed 4 cores
    requests.memory: "8Gi"   # Total memory requests cannot exceed 8Gi
    limits.cpu: "8"          # Total CPU limits cannot exceed 8 cores
    limits.memory: "16Gi"    # Total memory limits cannot exceed 16Gi
    pods: "50"               # Max number of pods allowed in this namespace
```
- The **hard** field defines **upper limits** on total resource usage in the namespace.  
- This ensures that all workloads within **my-namespace** stay within **defined boundaries**.  

---

### **Preventing Resource Exhaustion in Shared Clusters**  
In **multi-tenant Kubernetes clusters**, different teams or applications share the same infrastructure. Without resource constraints, a single team could:  
- **Consume too many resources**, causing scheduling failures for others.  
- **Overload a node**, leading to performance degradation.  

**Best Practices for Managing Resource Requests and Limits in Shared Clusters:**  
1. **Set up ResourceQuotas** for each namespace to **prevent overuse**.  
2. **Use LimitRanges** to ensure each pod requests a reasonable amount of resources.  
3. **Monitor namespace usage** with tools like **Prometheus**, **Grafana**, and `kubectl top`.  
4. **Adjust quotas dynamically** based on actual usage patterns.  

By enforcing **resource requests and limits** at the **namespace level**, Kubernetes administrators can maintain a **stable, fair, and efficient cluster environment** for all users.