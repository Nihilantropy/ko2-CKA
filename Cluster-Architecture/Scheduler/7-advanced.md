# **7. Advanced Scheduling Techniques**  

Advanced scheduling techniques in Kubernetes help optimize workload placement, manage resource constraints, and support complex multi-tenant environments. These techniques ensure efficient resource utilization, improve performance, and maintain cluster stability under varying workloads.  

---

## **7.1 Gang Scheduling**  

- **Definition**:  
  Gang scheduling ensures that a set of interdependent Pods (a "gang") is scheduled simultaneously, preventing scenarios where some Pods start while others remain in a pending state. This is useful for workloads like machine learning, big data processing, and HPC (High-Performance Computing).  

- **Implementation**:  
  - Kubernetes does not natively support gang scheduling, but it can be achieved using frameworks like **KubeFlow**, **Volcano**, or custom schedulers.  
  - Example configuration with **Volcano**:  
    ```yaml
    apiVersion: batch.volcano.sh/v1alpha1
    kind: Job
    metadata:
      name: mpi-job
    spec:
      minAvailable: 4
      schedulerName: volcano
      tasks:
        - replicas: 4
          name: mpi-worker
          template:
            spec:
              containers:
                - name: worker
                  image: mpi-worker-image
    ```

---

## **7.2 Node Pressure Eviction**  

- **Definition**:  
  Node pressure eviction occurs when Kubernetes automatically evicts Pods from Nodes experiencing resource pressure (e.g., high CPU, memory, or disk usage). This prevents system failures and keeps critical services running.  

- **Eviction Triggers**:  
  - **Memory Pressure**: If a Node runs low on available memory, Pods consuming excessive memory are evicted.  
  - **CPU Pressure**: Although CPU limits do not trigger eviction, Nodes may throttle workloads.  
  - **Disk Pressure**: If ephemeral storage usage exceeds limits, Pods are evicted.  

- **Configuring Eviction Thresholds**:  
  - Modify the **kubelet eviction thresholds** in the Node configuration:  
```sh
  kubelet --eviction-hard=memory.available<500Mi,nodefs.available<10%
  ```
  - Example Pod using `emptyDir` for disk-intensive applications:  
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: disk-intensive-app
    spec:
      containers:
        - name: app
          image: busybox
          volumeMounts:
            - mountPath: "/data"
              name: cache-volume
      volumes:
        - name: cache-volume
          emptyDir: {}
    ```

---

## **7.3 Scheduling Multi-Tenant Workloads**  

- **Definition**:  
  Multi-tenant scheduling ensures fair resource distribution and security for workloads belonging to different teams, projects, or organizations within a shared Kubernetes cluster.  

- **Best Practices**:  
  - **Namespace Isolation**: Assign separate namespaces to tenants to enforce logical separation.  
```sh
    kubectl create namespace tenant-a
    kubectl create namespace tenant-b
```
  - **Resource Quotas**: Prevent one tenant from consuming excessive resources.  
    ```yaml
    apiVersion: v1
    kind: ResourceQuota
    metadata:
      name: tenant-quota
      namespace: tenant-a
    spec:
      hard:
        requests.cpu: "2"
        requests.memory: "4Gi"
        limits.cpu: "4"
        limits.memory: "8Gi"
    ```
  - **Taints and Tolerations**: Assign workloads to specific Nodes using taints and tolerations.  
```sh
    kubectl taint nodes node1 tenant=special:NoSchedule
```
    ```yaml
    tolerations:
      - key: "tenant"
        operator: "Equal"
        value: "special"
        effect: "NoSchedule"
    ```
  - **Priority Classes**: Assign priority levels to workloads.  
    ```yaml
    apiVersion: scheduling.k8s.io/v1
    kind: PriorityClass
    metadata:
      name: high-priority
    value: 100000
    globalDefault: false
    description: "Priority for critical tenant workloads"
    ```

---

These advanced scheduling techniques enhance Kubernetes cluster efficiency by ensuring fair resource distribution, handling resource pressure dynamically, and supporting complex workloads that require synchronized scheduling.