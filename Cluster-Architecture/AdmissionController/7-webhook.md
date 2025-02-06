## 7. **Admission Controller Webhook Configuration**

Admission controllers that use webhooks provide the flexibility to enforce custom policies on Kubernetes resources at runtime. Setting up webhook-based admission controllers involves configuring Kubernetes to send admission requests to external webhooks, which can validate or mutate the resources based on the logic defined in the webhooks. In this section, we will explore the process of setting up and configuring admission control webhooks, defining webhook endpoints, and providing examples of webhook admission controllers.

### **Setting Up Admission Control Webhooks**

To use webhook-based admission controllers in Kubernetes, the following steps must be followed:

1. **Webhook Server Setup**:
   The first step is to set up the webhook server, which will receive admission requests from the Kubernetes API server. The webhook server should implement the logic for either mutating or validating the resources based on the admission request.

   The webhook server can be implemented in any language that can handle HTTP requests. Kubernetes expects the server to expose an HTTPS endpoint that can process `AdmissionReview` requests.

   The server should respond with a decision (approve, reject, or mutate) in the `AdmissionReview` format, which includes any modifications if it's a mutating webhook.

2. **Kubernetes API Server Configuration**:
   Once the webhook server is set up, the Kubernetes API server must be configured to communicate with it. This is done by creating a `MutatingWebhookConfiguration` or `ValidatingWebhookConfiguration` resource that points to the webhook server. The Kubernetes API server will call the webhook endpoints when certain operations are performed on resources.

3. **TLS Configuration**:
   Kubernetes requires webhook servers to use HTTPS for secure communication. You need to create and manage TLS certificates for the webhook server. The `caBundle` field in the webhook configuration allows you to provide the CA certificate to verify the authenticity of the webhook server.

   The webhook configuration will need the CA bundle to verify the certificate of the webhook server. If the server is self-signed, the CA certificate must be provided in the `caBundle` field.

### **Defining Webhook Endpoints**

Webhook endpoints define where the Kubernetes API server will send the admission requests. These endpoints are defined in the webhook configuration (either `MutatingWebhookConfiguration` or `ValidatingWebhookConfiguration`). Each configuration will contain the URL and the specific operation(s) that trigger the webhook.

- **Webhook URL**: The URL specifies where the API server should send the admission request. This could be an external URL or a service running within the Kubernetes cluster (e.g., using `https://webhook-service.namespace.svc.cluster.local`).

- **Operations**: The operations specify when the webhook should be called, such as on `CREATE`, `UPDATE`, or `DELETE` of resources.

- **Rules**: The rules specify the resource types and API groups that the webhook will process, including any specific API versions.

- **Admission Review Version**: The version of the `AdmissionReview` object that the webhook expects. Kubernetes supports multiple versions of `AdmissionReview` (e.g., `v1`).

### **Example Webhook Admission Controllers**

Here are a few examples of webhook admission controller configurations in YAML format:

#### Example 1: Mutating Webhook for Pods

This example shows how to set up a **MutatingAdmissionWebhook** to automatically inject a label into a Pod when it is created.

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: pod-mutating-webhook
webhooks:
  - name: mutate-pod.example.com
    clientConfig:
      url: https://webhook-service.default.svc.cluster.local/mutate
      caBundle: <CA_CERTIFICATE_HERE>  # Base64-encoded CA cert to verify webhook server
    rules:
      - operations: ["CREATE"]
        apiGroups: ["apps"]
        apiVersions: ["v1"]
        resources: ["pods"]
    admissionReviewVersions: ["v1"]
    sideEffects: None
```

- This configuration tells Kubernetes to call the webhook server at `https://webhook-service.default.svc.cluster.local/mutate` when a Pod is created in the `apps/v1` API group.
- The webhook will inject labels into the Pod specification before it is created.
- The `caBundle` is used for securing the communication and verifying the webhook server.

#### Example 2: Validating Webhook for Resource Limits

This example shows how to set up a **ValidatingAdmissionWebhook** to reject Pods that do not specify resource requests and limits.

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: resource-limit-validation-webhook
webhooks:
  - name: validate-resource-limits.example.com
    clientConfig:
      url: https://webhook-service.default.svc.cluster.local/validate
      caBundle: <CA_CERTIFICATE_HERE>  # Base64-encoded CA cert
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: ["apps"]
        apiVersions: ["v1"]
        resources: ["pods"]
    admissionReviewVersions: ["v1"]
    sideEffects: None
```

- This configuration validates Pods during `CREATE` and `UPDATE` operations.
- The webhook ensures that any Pod resource being created or updated contains valid resource requests and limits. If the Pod specification is missing these values, the webhook will reject the request.
- The webhook communicates securely over HTTPS using a CA certificate.

#### Example 3: Webhook Service Deployment

Here’s how to deploy a webhook service within the cluster that will handle the webhook requests. This example uses a basic Go server as the webhook service.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook-server
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook-server
  template:
    metadata:
      labels:
        app: webhook-server
    spec:
      containers:
      - name: webhook-server
        image: webhook-server:latest
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: webhook-server
  namespace: default
spec:
  ports:
    - port: 443
      targetPort: 8080
  selector:
    app: webhook-server
```

- This deployment creates a webhook service running in the `default` namespace that listens on port `8080`.
- The service is accessible via `https://webhook-server.default.svc.cluster.local`.
- The service listens for incoming admission requests and processes them accordingly.

### **Validating the Webhook Configuration**

Once the webhook and its configuration are deployed, you can validate the configuration by inspecting the `MutatingWebhookConfiguration` or `ValidatingWebhookConfiguration` resources in Kubernetes. You can also test the webhook server by creating or updating resources that match the rules in the configuration.

To check the status of the webhook configuration:

```bash
kubectl get mutatingwebhookconfigurations
kubectl get validatingwebhookconfigurations
```

You can also view the logs of the webhook server to ensure it is receiving and processing requests properly:

```bash
kubectl logs -f deployment/webhook-server
```

### **Troubleshooting Webhook Issues**

Common issues when configuring webhook admission controllers include:

1. **Certificate Issues**: Ensure that the `caBundle` in the webhook configuration matches the CA certificate used by the webhook server. Misconfigured certificates can result in TLS handshake errors.
2. **Networking Issues**: Make sure the webhook server is accessible by the Kubernetes API server. If using a service within the cluster, confirm that DNS resolution and service endpoints are correct.
3. **Timeouts**: Webhook servers should respond to admission requests promptly. If a webhook server is slow or unreachable, the Kubernetes API server will time out the request.

### **Conclusion**

Setting up webhook-based admission controllers provides a powerful and flexible way to enforce policies and ensure resource compliance in a Kubernetes cluster. By defining webhook endpoints, configuring secure communication with TLS, and implementing custom logic in webhook servers, administrators can enforce granular control over the resources that are created, updated, or deleted in the cluster. Whether using mutating or validating admission controllers, webhooks offer a highly extensible solution for Kubernetes cluster governance.