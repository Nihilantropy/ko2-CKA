## 4. **Enabling and Disabling Admission Controllers**

Admission controllers are an integral part of the Kubernetes API server, ensuring that all requests to the cluster are properly validated and mutated according to the defined policies. Configuring admission controllers in the Kubernetes API server and managing their behavior can help ensure that only valid, secure, and compliant resources are allowed into the cluster. Let’s dive into how to enable, disable, and configure these controllers, along with the most commonly enabled admission controllers.

### **Configuring Admission Controllers in the Kubernetes API Server**

Admission controllers are controlled via the **Kubernetes API server** configuration. The API server allows administrators to specify which admission controllers should be enabled or disabled through its command-line flags.

The `--enable-admission-plugins` and `--disable-admission-plugins` flags are used to control which controllers are enabled or disabled. These flags accept a comma-separated list of plugin names. Additionally, Kubernetes also supports using a configuration file to manage admission controllers, which provides more flexibility.

#### Configuration via Command-Line Flags

- **Enable Admission Controllers**: The `--enable-admission-plugins` flag specifies which admission controllers should be enabled. For example:
  
  ```bash
  --enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook,NamespaceLifecycle
  ```

- **Disable Admission Controllers**: The `--disable-admission-plugins` flag allows you to disable certain admission controllers if needed:
  
  ```bash
  --disable-admission-plugins=PodSecurityPolicy
  ```

It’s important to note that some admission controllers, like **`NamespaceLifecycle`** or **`LimitRanger`**, are enabled by default and cannot be disabled in some Kubernetes versions.

#### Configuration via API Server Flags

In the Kubernetes API server configuration file (`kube-apiserver`), you can specify admission controllers using the `--admission-control` parameter (or `--enable-admission-plugins` and `--disable-admission-plugins` for more granular control). Example configuration:

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: AdmissionConfiguration
admissionControl:
  enabled: 
    - "MutatingAdmissionWebhook"
    - "ValidatingAdmissionWebhook"
    - "LimitRanger"
  disabled: 
    - "PodSecurityPolicy"
```

This allows administrators to customize the set of admission controllers based on their needs, enabling only those that are necessary for their cluster environment.

### **Managing Admission Controller Behavior**

Managing the behavior of admission controllers involves controlling how they interact with requests, as well as configuring certain specific settings. Some controllers may allow fine-grained configuration through Kubernetes resources, while others may require custom logic via webhooks or configuration options.

#### 1. **Admission Webhook Configuration**:
   - **MutatingAdmissionWebhook** and **ValidatingAdmissionWebhook** are controlled via the **AdmissionRegistration API**, which allows Kubernetes clusters to manage webhook configurations dynamically. Webhooks have their own configuration resources, such as `MutatingWebhookConfiguration` or `ValidatingWebhookConfiguration`, where administrators can set the URL, timeouts, and other configurations.

   Example of a webhook configuration:
   ```yaml
   apiVersion: admissionregistration.k8s.io/v1
   kind: MutatingWebhookConfiguration
   metadata:
     name: example-mutating-webhook
   webhooks:
     - name: mutate.example.com
       clientConfig:
         url: https://webhook.example.com/mutate
       rules:
         - operations: ["CREATE"]
           apiGroups: ["apps"]
           apiVersions: ["v1"]
           resources: ["pods"]
   ```

   This configuration allows custom logic to mutate pod creation requests before they are persisted in the cluster.

#### 2. **Configuration for Built-in Controllers**:
   For certain admission controllers like `LimitRanger`, configuration options may be available directly within Kubernetes resources. For example, the `LimitRange` resource can be used to define resource limits for the pods within a namespace.

   Example `LimitRange` configuration:
   ```yaml
   apiVersion: v1
   kind: LimitRange
   metadata:
     name: limit-range
     namespace: default
   spec:
     limits:
     - max:
         cpu: 2
         memory: 4Gi
       min:
         cpu: 500m
         memory: 1Gi
       type: Container
   ```

   This configuration ensures that containers within the specified namespace adhere to the defined resource limits.

### **Commonly Enabled Admission Controllers**

Several admission controllers are commonly enabled by default in most Kubernetes clusters, as they provide important functionality such as security enforcement, resource management, and validation. Some of these controllers are vital for ensuring the proper functioning and security of a cluster.

#### Commonly Enabled Admission Controllers:
1. **`NamespaceLifecycle`**:
   Ensures that resources can only be created in namespaces that exist. It prevents creation of resources in non-existent namespaces.

2. **`LimitRanger`**:
   Enforces resource limits and requests for containers in a namespace. It ensures that containers cannot exceed certain resource constraints and can prevent resource over-provisioning.

3. **`ServiceAccount`**:
   Automatically assigns a service account to a pod if one is not specified. This controller ensures that each pod has the appropriate service account with the right permissions.

4. **`DefaultStorageClass`**:
   Ensures that any persistent volume claims (PVCs) that do not specify a `storageClassName` are assigned the default storage class.

5. **`ValidatingAdmissionWebhook`**:
   Enables external webhook-based validation of incoming resources, which can be customized to meet specific security, operational, or compliance requirements.

6. **`MutatingAdmissionWebhook`**:
   Enables external webhook-based mutation of incoming resources. This is useful for injecting sidecars, adding labels, or applying default values to resource configurations.

7. **`PodSecurityPolicy`** (Deprecated in newer versions in favor of `PodSecurity`):
   Enforces security policies for pod specifications, ensuring that pods do not run with privileged containers or insecure configurations.

8. **`ResourceQuota`**:
   Enforces resource quotas on namespaces to ensure that the overall resource usage within a namespace stays within a specified limit, helping to prevent resource exhaustion.

9. **`NodeRestriction`**:
   Restricts users from modifying node resources or accessing node-related information, which helps to maintain node-level security.

### Conclusion

Enabling and disabling admission controllers in Kubernetes provides cluster administrators with control over how resources are created, modified, and validated. By carefully selecting which admission controllers to enable or disable, and by configuring them appropriately, administrators can enforce security policies, ensure compliance, and automate common tasks. Kubernetes also allows for the use of webhooks to customize admission control behavior with external logic, offering even more flexibility in how resources are managed within the cluster.