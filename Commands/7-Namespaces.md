## **7. Working with Namespaces**  

Namespaces in Kubernetes allow for **logical isolation** of resources within a cluster, making it easier to manage different environments, teams, or applications.  

---

### **7.1. Listing and Inspecting Namespaces**  

- **List all namespaces in the cluster:**  
  ```sh
  kubectl get namespaces
  ```
  *(Shows all available namespaces, including system namespaces like `kube-system`, `default`, and `kube-public`.)*  

- **Get detailed information about a specific namespace:**  
  ```sh
  kubectl describe namespace <namespace>
  ```
  *(Displays metadata, resource quotas, and applied policies for the namespace.)*  

- **View all resources within a specific namespace:**  
  ```sh
  kubectl get all -n <namespace>
  ```
  *(Lists all pods, services, deployments, and other resources in a given namespace.)*  

- **Check the active namespace for the current context:**  
  ```sh
  kubectl config view --minify | grep namespace
  ```
  *(Helps verify the namespace currently set for operations.)*  

---

### **7.2. Creating and Managing Namespaces**  

- **Create a new namespace:**  
  ```sh
  kubectl create namespace <namespace>
  ```
  *(Creates a new logical grouping for resources.)*  

- **Create a namespace using a YAML definition:**  
  ```yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: <namespace>
  ```
  ```sh
  kubectl apply -f namespace.yaml
  ```
  *(Ensures namespace creation is managed declaratively.)*  

- **Set a namespace as default for the current session:**  
  ```sh
  kubectl config set-context --current --namespace=<namespace>
  ```
  *(Prevents the need to specify `-n <namespace>` for every command.)*  

- **Switch to a different namespace without changing the default:**  
  ```sh
  kubectl config use-context <context-name> --namespace=<namespace>
  ```
  *(Useful when managing multiple clusters and namespaces.)*  

---

### **7.3. Deleting and Cleaning Up Namespaces**  

- **Delete a namespace (removes all associated resources):**  
  ```sh
  kubectl delete namespace <namespace>
  ```
  *(Warning: This action **deletes all resources** within the namespace, including running workloads!)*  

- **Force delete a stuck namespace:**  
  ```sh
  kubectl get namespace <namespace> -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/<namespace>/finalize" -f -
  ```
  *(Useful if a namespace is stuck in the `Terminating` state due to finalizers.)*  

- **Delete all namespaces except system namespaces (`default`, `kube-system`, `kube-public`):**  
  ```sh
  kubectl get namespaces --no-headers | awk '$1 !~ /^(default|kube-system|kube-public)$/ {print $1}' | xargs kubectl delete namespace
  ```
  *(Cleans up user-created namespaces in a development environment.)*  

---

### **7.4. Running Workloads in a Specific Namespace**  

- **Create a pod in a specific namespace:**  
  ```sh
  kubectl run <pod-name> --image=<image> -n <namespace>
  ```
  *(Ensures that the pod is placed within the correct namespace.)*  

- **Deploy an application using a namespace in YAML:**  
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-app
    namespace: my-namespace
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: my-app
    template:
      metadata:
        labels:
          app: my-app
      spec:
        containers:
        - name: my-container
          image: nginx
  ```
  ```sh
  kubectl apply -f deployment.yaml
  ```
  *(Ensures the deployment is isolated within `my-namespace`.)*  

- **Expose a deployment as a service in a specific namespace:**  
  ```sh
  kubectl expose deployment my-app --port=80 --target-port=8080 --name=my-service -n my-namespace
  ```
  *(Ensures that the service is created in the correct namespace.)*  

---

### **7.5. Resource Quotas and Limits in Namespaces**  

Namespaces can enforce **resource quotas** to prevent excessive resource consumption.  

- **Create a resource quota for a namespace:**  
  ```yaml
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: namespace-quota
    namespace: my-namespace
  spec:
    hard:
      pods: "10"
      requests.cpu: "4"
      requests.memory: 4Gi
      limits.cpu: "8"
      limits.memory: 8Gi
  ```
  ```sh
  kubectl apply -f resource-quota.yaml
  ```
  *(Ensures that `my-namespace` cannot exceed the defined limits.)*  

- **View the current resource usage for a namespace:**  
  ```sh
  kubectl get resourcequota -n my-namespace
  ```
  *(Shows the quota limits and the amount currently consumed.)*  

---

### **7.6. Network Policies for Namespace Isolation**  

Kubernetes allows **network policies** to restrict traffic between namespaces.  

- **Deny all ingress traffic by default:**  
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: deny-all
    namespace: my-namespace
  spec:
    podSelector: {}
    policyTypes:
      - Ingress
  ```
  ```sh
  kubectl apply -f deny-all.yaml
  ```
  *(Ensures no external traffic can reach pods in `my-namespace`.)*  

- **Allow only traffic from a specific namespace:**  
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-from-namespace
    namespace: my-namespace
  spec:
    podSelector: {}
    policyTypes:
      - Ingress
    ingress:
      - from:
          - namespaceSelector:
              matchLabels:
                name: trusted-namespace
  ```
  ```sh
  kubectl apply -f allow-from-namespace.yaml
  ```
  *(Only allows communication from `trusted-namespace`.)*  

---

### **7.7. Handling Edge Cases**  

🔹 **Scenario 1: Check which namespace a running pod belongs to**  
```sh
kubectl get pod <pod-name> --all-namespaces
```
*(Helpful when searching for a pod across multiple namespaces.)*  

🔹 **Scenario 2: Moving resources between namespaces**  
```sh
kubectl get deployment my-app -n old-namespace -o yaml | sed 's/namespace: old-namespace/namespace: new-namespace/g' | kubectl apply -f -
kubectl delete deployment my-app -n old-namespace
```
*(Transfers a deployment from one namespace to another.)*  

🔹 **Scenario 3: Creating a namespace with a unique label for tracking**  
```sh
kubectl create namespace my-namespace --dry-run=client -o yaml | kubectl label -f - environment=staging | kubectl apply -f -
```
*(Adds an `environment=staging` label at creation time.)*  

Here's an **expanded and enhanced** version of the **Working with Namespaces** section, covering **advanced use cases, edge cases, and real-world scenarios**. 🚀  

---

## **7. Working with Namespaces**  

Namespaces in Kubernetes allow for **logical isolation** of resources within a cluster, making it easier to manage different environments, teams, or applications.  

---

### **7.1. Listing and Inspecting Namespaces**  

- **List all namespaces in the cluster:**  
  ```sh
  kubectl get namespaces
  ```
  *(Shows all available namespaces, including system namespaces like `kube-system`, `default`, and `kube-public`.)*  

- **Get detailed information about a specific namespace:**  
  ```sh
  kubectl describe namespace <namespace>
  ```
  *(Displays metadata, resource quotas, and applied policies for the namespace.)*  

- **View all resources within a specific namespace:**  
  ```sh
  kubectl get all -n <namespace>
  ```
  *(Lists all pods, services, deployments, and other resources in a given namespace.)*  

- **Check the active namespace for the current context:**  
  ```sh
  kubectl config view --minify | grep namespace
  ```
  *(Helps verify the namespace currently set for operations.)*  

---

### **7.2. Creating and Managing Namespaces**  

- **Create a new namespace:**  
  ```sh
  kubectl create namespace <namespace>
  ```
  *(Creates a new logical grouping for resources.)*  

- **Create a namespace using a YAML definition:**  
  ```yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: <namespace>
  ```
  ```sh
  kubectl apply -f namespace.yaml
  ```
  *(Ensures namespace creation is managed declaratively.)*  

- **Set a namespace as default for the current session:**  
  ```sh
  kubectl config set-context --current --namespace=<namespace>
  ```
  *(Prevents the need to specify `-n <namespace>` for every command.)*  

- **Switch to a different namespace without changing the default:**  
  ```sh
  kubectl config use-context <context-name> --namespace=<namespace>
  ```
  *(Useful when managing multiple clusters and namespaces.)*  

---

### **7.3. Deleting and Cleaning Up Namespaces**  

- **Delete a namespace (removes all associated resources):**  
  ```sh
  kubectl delete namespace <namespace>
  ```
  *(Warning: This action **deletes all resources** within the namespace, including running workloads!)*  

- **Force delete a stuck namespace:**  
  ```sh
  kubectl get namespace <namespace> -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/<namespace>/finalize" -f -
  ```
  *(Useful if a namespace is stuck in the `Terminating` state due to finalizers.)*  

- **Delete all namespaces except system namespaces (`default`, `kube-system`, `kube-public`):**  
  ```sh
  kubectl get namespaces --no-headers | awk '$1 !~ /^(default|kube-system|kube-public)$/ {print $1}' | xargs kubectl delete namespace
  ```
  *(Cleans up user-created namespaces in a development environment.)*  

---

### **7.4. Running Workloads in a Specific Namespace**  

- **Create a pod in a specific namespace:**  
  ```sh
  kubectl run <pod-name> --image=<image> -n <namespace>
  ```
  *(Ensures that the pod is placed within the correct namespace.)*  

- **Deploy an application using a namespace in YAML:**  
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-app
    namespace: my-namespace
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: my-app
    template:
      metadata:
        labels:
          app: my-app
      spec:
        containers:
        - name: my-container
          image: nginx
  ```
  ```sh
  kubectl apply -f deployment.yaml
  ```
  *(Ensures the deployment is isolated within `my-namespace`.)*  

- **Expose a deployment as a service in a specific namespace:**  
  ```sh
  kubectl expose deployment my-app --port=80 --target-port=8080 --name=my-service -n my-namespace
  ```
  *(Ensures that the service is created in the correct namespace.)*  

---

### **7.5. Resource Quotas and Limits in Namespaces**  

Namespaces can enforce **resource quotas** to prevent excessive resource consumption.  

- **Create a resource quota for a namespace:**  
  ```yaml
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: namespace-quota
    namespace: my-namespace
  spec:
    hard:
      pods: "10"
      requests.cpu: "4"
      requests.memory: 4Gi
      limits.cpu: "8"
      limits.memory: 8Gi
  ```
  ```sh
  kubectl apply -f resource-quota.yaml
  ```
  *(Ensures that `my-namespace` cannot exceed the defined limits.)*  

- **View the current resource usage for a namespace:**  
  ```sh
  kubectl get resourcequota -n my-namespace
  ```
  *(Shows the quota limits and the amount currently consumed.)*  

---

### **7.6. Network Policies for Namespace Isolation**  

Kubernetes allows **network policies** to restrict traffic between namespaces.  

- **Deny all ingress traffic by default:**  
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: deny-all
    namespace: my-namespace
  spec:
    podSelector: {}
    policyTypes:
      - Ingress
  ```
  ```sh
  kubectl apply -f deny-all.yaml
  ```
  *(Ensures no external traffic can reach pods in `my-namespace`.)*  

- **Allow only traffic from a specific namespace:**  
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-from-namespace
    namespace: my-namespace
  spec:
    podSelector: {}
    policyTypes:
      - Ingress
    ingress:
      - from:
          - namespaceSelector:
              matchLabels:
                name: trusted-namespace
  ```
  ```sh
  kubectl apply -f allow-from-namespace.yaml
  ```
  *(Only allows communication from `trusted-namespace`.)*  

---

### **7.7. Handling Edge Cases**  

🔹 **Scenario 1: Check which namespace a running pod belongs to**  
```sh
kubectl get pod <pod-name> --all-namespaces
```
*(Helpful when searching for a pod across multiple namespaces.)*  

🔹 **Scenario 2: Moving resources between namespaces**  
```sh
kubectl get deployment my-app -n old-namespace -o yaml | sed 's/namespace: old-namespace/namespace: new-namespace/g' | kubectl apply -f -
kubectl delete deployment my-app -n old-namespace
```
*(Transfers a deployment from one namespace to another.)*  

🔹 **Scenario 3: Creating a namespace with a unique label for tracking**  
```sh
kubectl create namespace my-namespace --dry-run=client -o yaml | kubectl label -f - environment=staging | kubectl apply -f -
```
*(Adds an `environment=staging` label at creation time.)*  

---

## **Real-World Namespace Management Strategies & CKA Exam Scenarios**  

Namespaces in Kubernetes help **organize and isolate workloads**, making them essential in **multi-tenant clusters, CI/CD pipelines, and security enforcement**. Below are **best practices, real-world strategies, and CKA exam-related scenarios** for **efficient namespace management.**  

---

## **8. Real-World Namespace Management Strategies**  

### **8.1. Multi-Tenancy in Kubernetes Clusters**  
🔹 **Scenario:** Your company has multiple teams (e.g., `frontend`, `backend`, `database`), and each team requires its own isolated environment.  

**Solution:**  
- Create **separate namespaces** for each team and enforce **RBAC policies** to ensure restricted access.  
- Implement **resource quotas** to prevent one team from consuming excessive cluster resources.  
- Apply **network policies** to restrict inter-namespace communication.  

✅ **Commands to Implement:**  
```sh
kubectl create namespace frontend
kubectl create namespace backend
kubectl create namespace database
```
  
- Enforce a **ResourceQuota** for the frontend team:  
  ```yaml
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: frontend-quota
    namespace: frontend
  spec:
    hard:
      pods: "10"
      requests.cpu: "4"
      requests.memory: 4Gi
      limits.cpu: "8"
      limits.memory: 8Gi
  ```
  ```sh
  kubectl apply -f frontend-quota.yaml
  ```

- Restrict network traffic using **NetworkPolicy**:  
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: frontend-isolation
    namespace: frontend
  spec:
    podSelector: {}
    policyTypes:
      - Ingress
  ```
  ```sh
  kubectl apply -f frontend-isolation.yaml
  ```

---

### **8.2. Namespaces in CI/CD Pipelines**  
🔹 **Scenario:** Your DevOps team needs to create a **temporary environment for each feature branch** in a CI/CD pipeline.  

**Solution:**  
- Create a **new namespace dynamically** for each pull request.  
- Deploy the application inside the namespace for testing.  
- Delete the namespace after the testing pipeline completes.  

✅ **Commands to Implement:**  
```sh
kubectl create namespace feature-branch-123
kubectl apply -f deployment.yaml -n feature-branch-123
kubectl delete namespace feature-branch-123
```

- **Automate Cleanup:**  
  ```sh
  kubectl get namespace --no-headers | awk '/feature-branch/{print $1}' | xargs kubectl delete namespace
  ```
  *(Deletes all feature-branch namespaces once they are no longer needed.)*  

---

### **8.3. Production Namespace Management**  
🔹 **Scenario:** Your company follows a **staging-to-production** deployment workflow, and you need to enforce strict separation between environments.  

**Solution:**  
- Create **`dev`, `staging`, and `prod` namespaces**.  
- Implement **RBAC roles** to ensure that only authorized personnel can modify the `prod` namespace.  
- Apply **pod security policies** to restrict running privileged containers in `prod`.  

✅ **Commands to Implement:**  
```sh
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod
```

- **Restrict Privileged Containers in `prod` Namespace**  
  ```yaml
  apiVersion: policy/v1beta1
  kind: PodSecurityPolicy
  metadata:
    name: restricted-psp
    namespace: prod
  spec:
    privileged: false
    allowPrivilegeEscalation: false
  ```
  ```sh
  kubectl apply -f restricted-psp.yaml
  ```

---

## **9. CKA Exam-Specific Namespace Scenarios**  

### **9.1. Find and Work with Resources in an Unknown Namespace**  
🔹 **Exam Scenario:** A pod named `web-app` exists in an unknown namespace. You must find it and get its logs.  

✅ **Solution:**  
```sh
kubectl get pods --all-namespaces | grep web-app
kubectl logs web-app -n <found-namespace>
```

---

### **9.2. Create a Namespace and Deploy a Pod Inside It**  
🔹 **Exam Scenario:** Create a namespace called `cka-test` and deploy an `nginx` pod inside it.  

✅ **Solution:**  
```sh
kubectl create namespace cka-test
kubectl run nginx --image=nginx -n cka-test
kubectl get pods -n cka-test
```

---

### **9.3. Set the Default Namespace for Commands**  
🔹 **Exam Scenario:** Ensure that all `kubectl` commands run in the `cka-test` namespace by default.  

✅ **Solution:**  
```sh
kubectl config set-context --current --namespace=cka-test
```
*(Prevents the need to use `-n cka-test` in every command.)*  

---

### **9.4. Delete a Stuck Namespace in `Terminating` State**  
🔹 **Exam Scenario:** A namespace is stuck in `Terminating` state due to a finalizer issue.  

✅ **Solution:**  
```sh
kubectl get namespace <namespace> -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/<namespace>/finalize" -f -
```

---

### **9.5. Restrict Access to a Namespace Using RBAC**  
🔹 **Exam Scenario:** Only users in the `dev-team` group should be allowed to manage resources in the `dev` namespace.  

✅ **Solution:**  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: dev-team-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "deployments"]
  verbs: ["get", "list", "create", "update", "delete"]
```
```sh
kubectl apply -f role.yaml
```
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: dev
  name: dev-team-binding
subjects:
- kind: Group
  name: dev-team
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: dev-team-role
  apiGroup: rbac.authorization.k8s.io
```
```sh
kubectl apply -f rolebinding.yaml
```

## **Advanced Namespace Strategies: Multi-Cluster Management, Security, and Monitoring**  

Namespaces are a **logical abstraction** for isolating workloads in a Kubernetes cluster. However, in **large-scale enterprise environments** or **multi-cluster deployments**, namespace strategies must be combined with **RBAC, network policies, security tools, and monitoring solutions** to ensure scalability, security, and observability.  

---

## **11. Multi-Cluster Namespace Strategies**  

### **11.1. Using Namespaces Across Multiple Clusters**  
🔹 **Scenario:** Your organization has multiple Kubernetes clusters (e.g., `us-east-cluster`, `us-west-cluster`) but wants a **consistent namespace structure** across clusters.  

✅ **Solution:**  
- Use **GitOps (ArgoCD, Flux)** to enforce **namespace consistency** across clusters.  
- Manage cluster-wide resources with **Kustomize/Helm** templates.  
- Implement **Federated Namespaces (KubeFed)** for multi-cluster namespace management.  

✅ **Example: Sync Namespaces Across Clusters Using `kubectl`**  
```sh
kubectl --context=us-east create namespace dev
kubectl --context=us-west create namespace dev
```

✅ **Example: Use Helm to Manage Namespaces**  
```sh
helm install my-namespace ./namespace-chart --set name=dev --namespace=dev
```

✅ **Example: Define a Federated Namespace in KubeFed**  
```yaml
apiVersion: types.kubefed.io/v1beta1
kind: FederatedNamespace
metadata:
  name: dev
  namespace: kube-federation-system
spec:
  template:
    metadata:
      labels:
        team: developers
  placement:
    clusters:
      - name: us-east-cluster
      - name: us-west-cluster
```
```sh
kubectl apply -f federated-namespace.yaml
```
*(Ensures a `dev` namespace is present in all federated clusters.)*  

---

### **11.2. Cross-Cluster Namespace Networking**  
🔹 **Scenario:** You need **cross-cluster communication** between services in different namespaces.  

✅ **Solution:**  
- Use **Istio multi-cluster mesh** to route traffic between namespaces in different clusters.  
- Set up **Kubernetes API Gateway (e.g., Kong, Traefik)** for cross-cluster access.  
- Utilize **subdomain-based namespace routing** with external DNS (`dev.example.com` → `dev` namespace).  

✅ **Example: Expose a Namespace as a Service Across Clusters**  
```sh
kubectl apply -f istio-mesh.yaml
kubectl apply -f service-export.yaml
```

---

## **12. Namespace-Based Security and Isolation**  

### **12.1. Implementing Network Policies for Namespace Isolation**  
🔹 **Scenario:** Prevent unauthorized access **between namespaces** while allowing controlled access between **frontend** and **backend**.  

✅ **Solution:**  
- Deny all inter-namespace traffic by default.  
- Allow only specific traffic (e.g., frontend → backend).  

✅ **Example: Deny All Traffic Except Internal Communication**  
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-external
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: frontend
```
```sh
kubectl apply -f network-policy.yaml
```
*(This allows only the `frontend` namespace to communicate with `backend`.)*  

---

### **12.2. Restrict Namespace-Level Permissions with RBAC**  
🔹 **Scenario:** Developers should **only have read access** to `prod`, but full access to `dev`.  

✅ **Solution:**  
- Create **namespace-scoped RBAC roles**.  
- Assign **RoleBindings** to different teams.  

✅ **Example: Developer Read-Only Access to `prod`**  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: prod
  name: read-only-role
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "deployments"]
    verbs: ["get", "list"]
```
```sh
kubectl apply -f read-only-role.yaml
```

✅ **Example: Developer Full Access to `dev`**  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: developer-role
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
```
```sh
kubectl apply -f developer-role.yaml
```
*(Developers can modify resources in `dev`, but only view `prod`.)*  

---

### **12.3. Limit Namespace Resource Consumption with Quotas**  
🔹 **Scenario:** Prevent a team from over-consuming cluster resources by **enforcing CPU and memory limits per namespace**.  

✅ **Solution:** Apply **ResourceQuotas** to enforce per-namespace resource limits.  

✅ **Example: Limit Namespace to 10 Pods and 8 CPU Cores**  
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: "4Gi"
    limits.cpu: "8"
    limits.memory: "8Gi"
```
```sh
kubectl apply -f team-quota.yaml
```
*(This restricts the `dev` namespace to 10 pods and 8 CPU cores max.)*  

---

## **13. Monitoring and Observability of Namespaces**  

### **13.1. Monitoring Namespace Metrics with Prometheus & Grafana**  
🔹 **Scenario:** You need **real-time monitoring** of namespace resource usage.  

✅ **Solution:**  
- Deploy **Prometheus** to scrape namespace-level metrics.  
- Use **Grafana dashboards** to visualize namespace usage.  

✅ **Example: Deploy Prometheus Node Exporter for Namespace-Level Monitoring**  
```sh
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl apply -f namespace-monitoring.yaml
```

✅ **Example: Query Namespace Metrics in PromQL**  
```promql
sum by (namespace) (container_memory_usage_bytes)
```
*(This shows memory usage per namespace.)*  

---

### **13.2. Logging and Auditing Namespace Activities**  
🔹 **Scenario:** Track **who made changes to resources** within a namespace.  

✅ **Solution:**  
- Enable **Kubernetes Audit Logging**.  
- Use **Fluentd + Elasticsearch + Kibana (EFK Stack)** for namespace-based log aggregation.  

✅ **Example: Enable Audit Logging for Namespace Events**  
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: RequestResponse
    resources:
      - group: ""
        resources: ["namespaces", "pods", "services"]
```
```sh
kubectl apply -f audit-policy.yaml
```
*(This captures **all requests and responses** for namespaces.)*  

✅ **Example: View Namespace-Specific Logs in Fluentd**  
```sh
kubectl logs fluentd -n logging | grep "namespace=dev"
```
*(Filters logs for the `dev` namespace.)*  

---

## **14. Summary of Advanced Namespace Best Practices**  

✅ **Multi-cluster namespace consistency** using **KubeFed, Helm, and GitOps**.  
✅ **Namespace-based networking** using **Istio and API Gateways**.  
✅ **Security isolation** using **Network Policies and RBAC**.  
✅ **Resource quotas** to prevent overuse in shared environments.  
✅ **Monitoring with Prometheus, Grafana, and Fluentd**.  
✅ **Audit logging** to track namespace-based activity.  
