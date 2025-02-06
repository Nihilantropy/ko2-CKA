## 3. **Types of Admission Controllers**

Kubernetes Admission Controllers are categorized into different types based on their roles and functionality. The two primary types are **Mutating Admission Controllers** and **Validating Admission Controllers**. Additionally, **Webhook Admission Controllers** are used to extend Kubernetes’ admission control with custom logic. Let’s explore these types in more detail:

### **Mutating Admission Controllers**

**Mutating Admission Controllers** are designed to modify the incoming request before it is stored in the Kubernetes API server’s etcd storage. These controllers can alter the configuration of the resource being created or modified, such as adding default values or modifying existing fields to ensure consistency across the cluster.

#### Key Features of Mutating Admission Controllers:
- **Modify Resources**: They have the ability to add, change, or remove fields from a resource’s configuration. For example, a mutating controller can automatically inject environment variables into pods or add default labels/annotations to deployments.
- **Configuration Defaults**: They are often used to enforce configuration defaults, ensuring that resources are created with the necessary settings (e.g., adding default resource requests/limits, labels, or annotations).
- **Automatically Injecting Configurations**: They can automatically inject configuration or sidecar containers, security settings (like service account names), and network policies into pods.
  
#### Examples of Mutating Admission Controllers:
- **`MutatingAdmissionWebhook`**: A webhook-based controller that allows external systems to modify resource requests (e.g., injecting labels, modifying pod specifications).
- **`NamespaceLifecycle`**: Ensures that resources are only created in valid namespaces that exist.
- **`PodPreset`**: Automatically injects certain configurations (such as environment variables or volume mounts) into pods before they are created.

### **Validating Admission Controllers**

**Validating Admission Controllers** are responsible for ensuring that the resource being created or modified adheres to predefined policies or standards. These controllers **do not modify** the resource; instead, they validate the content of the resource and approve or reject the request based on the criteria set by the cluster administrators.

#### Key Features of Validating Admission Controllers:
- **Enforce Policies**: These controllers enforce rules and policies, ensuring that requests comply with security, operational, and organizational standards (e.g., enforcing resource limits, security policies, or access control).
- **Reject Non-Compliant Requests**: If a request fails validation, the admission controller rejects it, preventing the resource from being created or updated.
- **No Modification**: Unlike mutating controllers, validating controllers cannot change the resource; they only approve or deny the operation based on compliance checks.

#### Examples of Validating Admission Controllers:
- **`ValidatingAdmissionWebhook`**: A webhook-based controller that allows custom validation logic to be applied externally, such as ensuring that all containers in a pod are using an approved image or enforcing labeling conventions.
- **`LimitRanger`**: Ensures that resources like CPU and memory requests/limits are set correctly for pods and containers.
- **`PodSecurityPolicy`**: Validates that pods meet security policies, such as ensuring that privileged containers are not allowed, or that certain security contexts are set.

### **Webhook Admission Controllers**

**Webhook Admission Controllers** are a specific implementation of both mutating and validating admission controllers that allow external HTTP-based webhooks to be invoked for admission control purposes. These webhooks provide an extension point for Kubernetes to include custom admission logic that is not part of the default controller set.

Webhook admission controllers are divided into two categories:
- **Mutating Admission Webhooks**: These webhooks can modify the incoming request by adding or altering data before it reaches the Kubernetes API server's storage.
- **Validating Admission Webhooks**: These webhooks validate the incoming request, rejecting it if it fails to meet the defined criteria.

#### Key Features of Webhook Admission Controllers:
- **External Custom Logic**: Webhook controllers provide an ability to integrate external systems for custom admission logic, enabling complex validation and mutation rules based on business-specific requirements.
- **Custom Policies**: Organizations can implement their own security policies, compliance rules, or resource management logic using webhook admission controllers.
- **Flexible**: They offer flexibility in customizing and extending admission control beyond Kubernetes’ built-in capabilities.

#### How Webhooks Work:
1. **Mutating Webhook**: When a resource is created, the API server calls the webhook with the resource's configuration. The webhook can mutate (modify) the resource and send it back with the changes. This mutated request is then processed by other controllers or stored in etcd.
2. **Validating Webhook**: After the resource is potentially mutated, the API server calls the validating webhook. The webhook checks whether the resource is valid according to the organization's rules and either approves or rejects the request.

#### Examples of Webhook Admission Controllers:
- **`MutatingAdmissionWebhook`**: A webhook that automatically injects labels or sidecar containers into pods.
- **`ValidatingAdmissionWebhook`**: A webhook that checks whether the pod image is from a trusted registry or whether certain labels are applied to all resources for compliance.

### Summary of Admission Controller Types

| Admission Controller Type     | Description                                                                                   | Examples                                                   |
|-------------------------------|-----------------------------------------------------------------------------------------------|------------------------------------------------------------|
| **Mutating Admission Controllers**  | Modifies incoming requests before they are persisted in etcd.                                  | `PodPreset`, `MutatingAdmissionWebhook`, `NamespaceLifecycle` |
| **Validating Admission Controllers**| Ensures that requests meet defined policies before they are persisted in etcd.                  | `LimitRanger`, `ValidatingAdmissionWebhook`, `PodSecurityPolicy` |
| **Webhook Admission Controllers** | External webhooks that extend mutating or validating admission controllers with custom logic. | `MutatingAdmissionWebhook`, `ValidatingAdmissionWebhook`     |

### Conclusion

Admission Controllers in Kubernetes are crucial for ensuring the integrity, security, and compliance of resources within the cluster. **Mutating Admission Controllers** modify the resource before it is persisted, while **Validating Admission Controllers** ensure that the resource adheres to policies. **Webhook Admission Controllers** extend the capabilities of admission controllers with external, customizable logic. These controllers together form an essential layer of security and policy enforcement within Kubernetes clusters.