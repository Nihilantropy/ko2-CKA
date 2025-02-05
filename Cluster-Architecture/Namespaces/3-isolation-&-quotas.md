# **3. Resource Isolation and Quotas**

Resource isolation is a key aspect of managing a multi-tenant Kubernetes cluster. By leveraging Resource Quotas, Limit Ranges, and Network Policies, you can control how resources are consumed and ensure fair allocation among different teams or applications.

---

## **3.1 Resource Quotas**

- **Purpose**:  
  Resource Quotas allow administrators to limit the total resource consumption (such as CPU, memory, and the number of objects like pods or services) within a namespace. This prevents any single team or application from monopolizing cluster resources.

- **Usage**:  
  You can define a ResourceQuota using a YAML manifest and apply it to a namespace.  
  **Example YAML**:
  ```yaml
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: compute-resources
    namespace: my-namespace
  spec:
    hard:
      pods: "10"                # Limit to 10 pods in the namespace
      requests.cpu: "4"         # Total CPU requested by all pods must not exceed 4 cores
      requests.memory: "8Gi"      # Total memory requested must not exceed 8Gi
      limits.cpu: "8"           # Total CPU limits for all pods must not exceed 8 cores
      limits.memory: "16Gi"      # Total memory limits for all pods must not exceed 16Gi
  ```
- **Benefits**:  
  By enforcing these limits, Resource Quotas help maintain cluster stability and prevent resource exhaustion.

---

## **3.2 Limit Ranges**

- **Purpose**:  
  Limit Ranges set minimum and maximum constraints for resource consumption at the pod or container level within a namespace. This ensures that individual workloads operate within acceptable boundaries.

- **Usage**:  
  You can specify default limits and request values for containers if none are provided in the pod specification.  
  **Example YAML**:
  ```yaml
  apiVersion: v1
  kind: LimitRange
  metadata:
    name: limits
    namespace: my-namespace
  spec:
    limits:
      - type: Container
        max:
          cpu: "2"            # Maximum CPU per container is 2 cores
          memory: "4Gi"         # Maximum memory per container is 4Gi
        min:
          cpu: "200m"         # Minimum CPU per container is 200m
          memory: "128Mi"       # Minimum memory per container is 128Mi
  ```
- **Benefits**:  
  This prevents a container from using too many resources while ensuring that a minimum amount is always available for proper operation.

---

## **3.3 Network Policies for Namespace Isolation**

- **Purpose**:  
  Network Policies control the flow of traffic at the IP address or port level between pods within the same namespace or across different namespaces. They help enforce security boundaries and isolate workloads from unintended access.

- **Usage**:  
  A basic Network Policy can restrict traffic to only allow communication between specific pods.  
  **Example YAML**:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: restrict-traffic
    namespace: my-namespace
  spec:
    podSelector:
      matchLabels:
        role: backend
    policyTypes:
      - Ingress
    ingress:
      - from:
          - podSelector:
              matchLabels:
                access: allowed
  ```
- **Benefits**:  
  Network Policies enhance security by ensuring that only authorized pods can communicate with each other, reducing the risk of lateral movement in the event of a compromise.

---

Resource isolation through Resource Quotas, Limit Ranges, and Network Policies plays a crucial role in maintaining a balanced, secure, and efficient Kubernetes environment. These mechanisms provide granular control over resource distribution and network access, supporting both stability and security in multi-tenant clusters.