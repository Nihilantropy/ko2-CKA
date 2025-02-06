## 6. **Using Admission Controllers for Security**

Admission controllers play a crucial role in enforcing security policies in a Kubernetes cluster by validating and mutating resources before they are persisted. By utilizing various admission controllers, administrators can prevent misconfigurations, ensure compliance with security policies, and protect cluster resources from unauthorized access. Admission controllers can be used to secure resources in several key areas, such as network policies, resource limits, and more.

### **Securing Resources with Admission Controllers**

Admission controllers can enforce security practices across Kubernetes resources, ensuring that pods, services, and other objects follow secure configurations. This prevents the deployment of insecure workloads or configurations that might otherwise compromise the integrity of the cluster.

Here are some common admission controllers used for securing resources:

- **PodSecurityPolicy (Deprecated)**:
  The **PodSecurityPolicy (PSP)** admission controller was used to enforce security constraints on pods, such as restricting privileged containers, preventing the use of certain capabilities, and enforcing security context settings. Though **PSP** is deprecated in newer versions of Kubernetes, it was a foundational tool for controlling pod security policies in clusters.

  Example PSP settings could include:
  - Preventing the use of privileged containers.
  - Requiring certain security context settings, such as `runAsUser`.
  - Disallowing the mounting of host filesystems.

  With the deprecation of PSP, Kubernetes recommends using the **PodSecurity** admission controller, which is part of the newer **PodSecurity** standards for enforcing cluster-wide security policies.

- **NetworkPolicy**:
  Admission controllers can be used to enforce network security policies that control the communication between pods. The **NetworkPolicy** admission controller allows Kubernetes clusters to define how pods can communicate with each other, limiting access to only the necessary services.

  For example, the **NetworkPolicy** controller can ensure that certain pods are only accessible from other specific pods or namespaces, providing an additional layer of security in multi-tenant environments.

- **ServiceAccount**:
  The **ServiceAccount** admission controller ensures that a service account is automatically assigned to pods if one is not specified. Service accounts are essential for controlling access to Kubernetes API resources. Without a service account, a pod would not have any identity or access control to interact with Kubernetes resources securely.

  Admission controllers can enforce strict service account management by ensuring that only authorized service accounts are used within specific namespaces.

- **SecurityContextDeny**:
  The **SecurityContextDeny** admission controller can be used to prevent the deployment of containers that do not meet the required security context settings, such as containers running as root or containers with excessive privileges.

  Example use cases include:
  - Ensuring that containers run as non-root users.
  - Disabling the use of privileged mode for containers.

### **Admission Control for Network Policies**

Network policies are crucial for securing pod communication within Kubernetes clusters. Admission controllers help enforce these policies by ensuring that only valid network policy resources are created and adhered to. By using network policy-related admission controllers, administrators can control which pods are allowed to communicate with each other, thereby restricting unauthorized or malicious access.

#### Key Admission Controllers for Network Security:
1. **ValidatingAdmissionWebhook**:
   The **ValidatingAdmissionWebhook** can be configured to validate the correctness and security of network policies before they are applied. This webhook can check that the network policies do not contain insecure configurations, such as allowing unrestricted access between pods or namespaces.

2. **MutatingAdmissionWebhook**:
   The **MutatingAdmissionWebhook** can automatically inject labels or sidecar containers into the network policies to enforce common patterns across the cluster. For example, it can add security-enhancing labels to network policy resources, ensuring that they adhere to cluster-wide security requirements.

3. **NetworkPolicy Admission**:
   Network policies are crucial for securing communication between workloads in the cluster. Kubernetes' built-in **NetworkPolicy** admission controller ensures that only network policies that conform to the expected format and security guidelines are applied.

   Example:
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-specific-app
   spec:
     podSelector:
       matchLabels:
         app: "my-app"
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: "trusted-app"
   ```
   This example defines a network policy allowing traffic only from a pod with the `app: trusted-app` label. By enforcing such policies using admission controllers, administrators can enforce strict controls over communication in the cluster.

### **Admission Controllers for Resource Limits**

Admission controllers can also help ensure that resource constraints (e.g., CPU and memory limits) are adhered to when deploying workloads, which is essential for maintaining a secure and stable cluster. Without proper resource management, workloads might monopolize cluster resources, leading to instability and performance degradation. Admission controllers enforce limits on resources such as CPU, memory, and disk, ensuring that no pod can exceed the predefined limits or go unbounded.

#### Key Admission Controllers for Resource Management:
1. **LimitRanger**:
   The **LimitRanger** admission controller enforces limits and requests for resources (such as CPU and memory) on containers in a namespace. If no limits or requests are specified, it can apply defaults to ensure that every container has defined resource constraints.

   Example `LimitRange` resource:
   ```yaml
   apiVersion: v1
   kind: LimitRange
   metadata:
     name: default-limits
     namespace: default
   spec:
     limits:
     - max:
         cpu: "2"
         memory: "4Gi"
       min:
         cpu: "500m"
         memory: "1Gi"
       type: Container
   ```
   In this example, a `LimitRange` is used to ensure that containers in the `default` namespace do not use more than 2 CPU cores and 4Gi of memory, and they must request at least 500m of CPU and 1Gi of memory.

2. **ResourceQuota**:
   The **ResourceQuota** admission controller ensures that the overall resource usage within a namespace does not exceed a predefined limit. It can control how many resources (such as pods, services, or persistent volume claims) can be created in a namespace and prevent excessive resource consumption by any single team or user.

   Example `ResourceQuota` resource:
   ```yaml
   apiVersion: v1
   kind: ResourceQuota
   metadata:
     name: resource-quota
     namespace: default
   spec:
     hard:
       pods: "10"
       requests.cpu: "4"
       requests.memory: "8Gi"
   ```
   This example defines a `ResourceQuota` for the `default` namespace, limiting the creation of pods to 10 and ensuring that the total CPU and memory requests in the namespace do not exceed 4 CPUs and 8Gi of memory.

3. **LimitRanger**:
   Another security-focused feature, **LimitRanger**, can help enforce policies around resource limits and requests. By ensuring that every container in a namespace has defined limits and requests, administrators can prevent pod over-provisioning or under-provisioning, leading to more predictable resource utilization.

### **Conclusion**

Admission controllers are a powerful mechanism for securing Kubernetes clusters by enforcing policies on workloads at runtime. By using admission controllers for resource limits, network policies, and security configurations, administrators can ensure that resources are deployed and run securely, reducing the risk of misconfigurations, overuse of resources, and unauthorized access. Customizing admission controllers and using tools such as **MutatingAdmissionWebhook**, **ValidatingAdmissionWebhook**, and **LimitRanger** enables administrators to enforce security policies and manage resources effectively, ensuring a secure, compliant, and stable Kubernetes environment.