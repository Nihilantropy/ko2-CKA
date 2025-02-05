# **4. Namespace-based Access Control**

Namespaces in Kubernetes provide a natural boundary for applying security and access control policies. By leveraging Role-Based Access Control (RBAC) and Service Accounts, administrators can finely control who can access and manipulate resources within each namespace.

---

## **4.1 Role-Based Access Control (RBAC) in Namespaces**

- **Purpose**:  
  RBAC allows you to define and enforce policies that restrict or grant permissions to users, groups, or service accounts within a specific namespace.

- **Key Components**:
  - **Roles**: Define a set of permissions (verbs) on Kubernetes resources within a namespace.
  - **RoleBindings**: Bind the defined roles to users, groups, or service accounts, granting them the specified permissions.

- **Example Role Definition**:
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    namespace: my-namespace
    name: pod-reader
  rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "watch", "list"]
  ```

- **Example RoleBinding**:
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: read-pods
    namespace: my-namespace
  subjects:
  - kind: User
    name: jane.doe  # Replace with the actual username
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    kind: Role
    name: pod-reader
    apiGroup: rbac.authorization.k8s.io
  ```

- **Benefits**:  
  Using RBAC in namespaces ensures that only authorized users or applications have access to sensitive resources, promoting a secure multi-tenant environment.

---

## **4.2 Service Accounts and Namespace Permissions**

- **Purpose**:  
  Service Accounts provide an identity for processes that run in pods. They are used by applications to interact with the Kubernetes API and are essential for automated and secure access control.

- **Key Points**:
  - **Default Service Account**:  
    Each namespace is automatically assigned a default service account that pods use if no other is specified.
  
  - **Custom Service Accounts**:  
    You can create custom service accounts to grant specific permissions needed by your applications.
  
- **Example Service Account Creation**:
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: custom-sa
    namespace: my-namespace
  ```

- **Binding a Service Account to a Role**:
  Create a RoleBinding to grant the service account specific permissions:
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: sa-pod-access
    namespace: my-namespace
  subjects:
  - kind: ServiceAccount
    name: custom-sa
    namespace: my-namespace
  roleRef:
    kind: Role
    name: pod-reader
    apiGroup: rbac.authorization.k8s.io
  ```

- **Benefits**:  
  Service Accounts enhance security by isolating API credentials and reducing the risk of privilege escalation. They ensure that applications interact with the Kubernetes API using well-defined, limited privileges.

---

By implementing RBAC and utilizing Service Accounts at the namespace level, you can enforce granular access control policies that protect resources and maintain a secure, well-organized cluster environment.