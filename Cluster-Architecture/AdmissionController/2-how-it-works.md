## 2. **How Admission Controllers Work**

### Overview of the Admission Control Process

The **Admission Control** process occurs when a request is made to the Kubernetes API server to create, modify, or delete resources within the cluster. Admission Controllers intercept these requests at two points during their lifecycle: before the object is stored in etcd (the persistent storage), and before it is allowed to be executed in the cluster. Admission Controllers can either **mutate** the request by modifying it or **validate** it by ensuring that it meets certain criteria.

The Admission Control process in Kubernetes involves the following steps:

1. **Initial Request**: A request (e.g., to create or update a pod, deployment, or other Kubernetes resource) is made to the Kubernetes API server.
   
2. **Authentication and Authorization**: The request is first subject to authentication and authorization checks. This ensures that the user or system making the request has the proper credentials and permissions.

3. **Admission Control Phase**:
   - **Mutating Admission Controllers**: If there are any mutating controllers enabled, they are triggered first. These controllers can modify the request, adding, changing, or removing values from the resource before it is persisted to the cluster.
   - **Validating Admission Controllers**: After mutation, validating controllers are invoked to ensure that the resource adheres to defined policies. If any of the validating controllers reject the request, it is prevented from being applied to the cluster.
   
4. **Final Request**: If the request passes through both the mutating and validating phases, the resource is persisted in etcd, and the operation is completed (e.g., the pod is created, updated, or deleted).

This process ensures that Kubernetes resources are validated and modified according to the organization’s requirements and policies before they are committed to the cluster.

### Role of Webhooks in Admission Control

**Admission Webhooks** are HTTP callbacks that the API server invokes to perform admission control checks. Webhooks provide an extension point for custom admission logic in Kubernetes. When an admission controller is implemented via webhooks, the API server sends an HTTP request to a webhook server, which processes the request and returns a decision on whether the operation should proceed.

There are two types of webhooks in Kubernetes Admission Control:

- **Mutating Admission Webhooks**: These webhooks allow you to change the incoming request by modifying its fields. For example, a mutating webhook could add default labels, annotations, or resources to a pod spec automatically.
  
- **Validating Admission Webhooks**: These webhooks validate the request and can either approve or reject it based on custom policies or rules. If a validating webhook rejects a request, the API server will not proceed with the action, and the user will receive an error message.

The general process of a webhook in Admission Control involves the following:
1. The API server sends the admission request (containing the object) to the webhook server.
2. The webhook processes the request, applying custom logic.
3. The webhook returns a response to the API server, which contains the result of the admission decision:
   - **Allow**: The request is accepted and processed further.
   - **Deny**: The request is rejected, and the operation does not proceed.
   - **Mutate** (for mutating webhooks): The webhook modifies the resource and sends it back for further processing.

Webhooks allow Kubernetes to extend the admission control process beyond the built-in controllers, enabling custom policies, complex validation rules, and automated resource modification.

### The Life Cycle of an Admission Request

The life cycle of an admission request is as follows:

1. **Request Creation**: A client, such as `kubectl` or a Kubernetes controller, sends a request to the Kubernetes API server. This request may be to create, update, or delete a Kubernetes resource.

2. **Authentication and Authorization**: The API server first authenticates the request to ensure the client has valid credentials. Then, the request is authorized based on the client’s permissions and role-based access control (RBAC) settings.

3. **Admission Controller Execution**:
   - **Mutating Admission Controllers**: If mutating admission controllers are enabled, they are triggered before the resource is validated. These controllers can add or modify fields in the resource spec. The modified request is sent to the next step in the process.
   - **Validating Admission Controllers**: Once mutating controllers have had their effect (if any), the validating admission controllers are executed. These controllers inspect the resource and decide whether it adheres to specified policies (such as validating labels, resource limits, security settings, etc.). If any validating controller denies the request, the API server will reject the operation, and an error will be returned to the client.

4. **Final Decision**: If all the admission controllers allow the request (i.e., there are no denials), the resource is persisted in the cluster's etcd storage. The operation is then carried out, whether it is creating, updating, or deleting the resource.

5. **Response to Client**: After the request has been processed by the admission controllers, the final status is returned to the client. This could be a success response (e.g., a pod is created) or an error response (e.g., the resource is rejected due to validation failure).

### Key Takeaways:
- **Admission controllers** ensure that all resources created or modified in the cluster meet certain policies and specifications.
- **Mutating admission controllers** can change the resource specification, whereas **validating admission controllers** check compliance with rules and prevent non-compliant resources from being created.
- **Webhooks** extend admission control, allowing for custom admission logic through HTTP callbacks to an external server.
- The entire process is seamless, ensuring that Kubernetes clusters are secure, compliant, and automated by enforcing the desired policies and configurations.