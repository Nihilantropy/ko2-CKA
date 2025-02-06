## 5. **Custom Admission Controllers**

Kubernetes provides the flexibility to create **custom admission controllers** for scenarios where the built-in controllers do not meet the specific needs of your cluster. These custom controllers can either **mutate** resources before they are saved to the cluster or **validate** them to ensure compliance with policies. Custom admission controllers can be implemented using **Admission Webhooks**, which provide a mechanism to integrate external logic and policies.

### **Writing a Custom Admission Controller**

A **custom admission controller** typically consists of a webhook server that implements the logic for mutating or validating incoming requests. Writing such a controller involves creating a service that can accept HTTP requests from the Kubernetes API server, process them, and return a decision (approve, reject, or mutate) based on the custom logic.

1. **Define the Controller Logic**:
   - **Mutating Admission Controllers**: Write the logic that mutates (modifies) the resource configuration. For example, adding default labels or sidecar containers to a pod spec.
   - **Validating Admission Controllers**: Implement logic to validate the resource configuration against a set of rules or policies. For example, ensuring that all containers in a pod use images from an approved registry.

2. **Webhook Server Implementation**:
   The webhook server will expose an HTTP endpoint that the Kubernetes API server will call when an admission request is made. The server will receive a request containing the resource object in JSON format, process it according to the defined logic, and return a response in the form of an admission review.

   Example of a basic Mutating Webhook server in Go:
   ```go
   package main

   import (
       "encoding/json"
       "fmt"
       "log"
       "net/http"
   )

   type AdmissionReview struct {
       Kind    string `json:"kind"`
       APIVersion string `json:"apiVersion"`
       Request *AdmissionRequest `json:"request"`
   }

   type AdmissionRequest struct {
       UID     string `json:"uid"`
       Kind    struct {
           Kind string `json:"kind"`
       } `json:"kind"`
       Object json.RawMessage `json:"object"`
   }

   func mutateHandler(w http.ResponseWriter, r *http.Request) {
       var admissionReview AdmissionReview
       err := json.NewDecoder(r.Body).Decode(&admissionReview)
       if err != nil {
           http.Error(w, fmt.Sprintf("Error decoding admission review: %v", err), http.StatusBadRequest)
           return
       }

       // Your mutation logic goes here (e.g., add labels, set environment variables, etc.)
       
       response := AdmissionReview{
           Kind: "AdmissionReview",
           APIVersion: "admission.k8s.io/v1",
           Request: &AdmissionRequest{
               UID: admissionReview.Request.UID,
               Kind: admissionReview.Request.Kind,
               Object: admissionReview.Request.Object,
           },
       }

       admissionResponse := map[string]interface{}{
           "response": map[string]interface{}{
               "allowed": true,
           },
       }

       // Write the response
       w.Header().Set("Content-Type", "application/json")
       json.NewEncoder(w).Encode(admissionResponse)
   }

   func main() {
       http.HandleFunc("/mutate", mutateHandler)
       log.Fatal(http.ListenAndServe(":8080", nil))
   }
   ```

   This Go server listens for admission requests, processes them, and sends back an approval response. In practice, you would add custom mutation or validation logic to process the resource data as needed.

### **Registering and Deploying Custom Admission Controllers**

Once you've written your custom admission controller, the next step is to **deploy and register it** with the Kubernetes API server so that it can start processing admission requests.

#### Steps to Register and Deploy Custom Admission Controllers:

1. **Create a Webhook Configuration**:
   You need to create a **MutatingWebhookConfiguration** or **ValidatingWebhookConfiguration** to register your webhook with the Kubernetes API server. This configuration tells the API server how to reach your webhook server and when to invoke it.

   Example of a **MutatingWebhookConfiguration**:
   ```yaml
   apiVersion: admissionregistration.k8s.io/v1
   kind: MutatingWebhookConfiguration
   metadata:
     name: custom-mutating-webhook
   webhooks:
   - name: webhook.example.com
     clientConfig:
       url: https://webhook.example.com/mutate
       caBundle: <CA_CERTIFICATE_HERE>
     rules:
     - operations: ["CREATE"]
       apiGroups: ["apps"]
       apiVersions: ["v1"]
       resources: ["pods"]
     admissionReviewVersions: ["v1"]
     sideEffects: None
   ```

   The `clientConfig.url` field points to the endpoint where your webhook server is hosted. If your webhook server is deployed as a service within a Kubernetes cluster, you can use a service URL like `https://webhook-service.namespace.svc.cluster.local/mutate`.

   - **`caBundle`**: The Certificate Authority (CA) bundle is used to ensure secure communication between the Kubernetes API server and your webhook server.
   - **`rules`**: Specifies when the webhook should be triggered. In this case, the webhook will be invoked on `CREATE` operations for `pods` in the `apps/v1` API group.

2. **Deploy the Webhook Server**:
   You will need to deploy the webhook server to a location where the Kubernetes API server can reach it. This can be done by creating a Kubernetes service and deployment for your webhook server. For example:
   
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: webhook-server
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
           image: my-webhook-server-image:latest
           ports:
           - containerPort: 8080
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: webhook-server
   spec:
     ports:
     - port: 443
       targetPort: 8080
     selector:
       app: webhook-server
   ```

   Once the webhook server is deployed, Kubernetes will call it whenever a resource matching the defined rules is created.

3. **Verify Registration**:
   After the webhook configuration and server are deployed, you can check whether the admission controller is properly registered by using `kubectl`:
   
   ```bash
   kubectl get mutatingwebhookconfigurations
   ```

   This will show the list of mutating admission controllers, including your custom one.

### **Handling Mutating and Validating Webhooks**

**Mutating Webhooks** and **Validating Webhooks** are handled differently within the Kubernetes admission control pipeline:

- **Mutating Webhooks**: Mutating webhooks are invoked first in the admission control process. They receive the resource object, modify it if necessary, and return the modified object to the API server. The modified object is then processed by any other admission controllers, such as validating webhooks.

- **Validating Webhooks**: Validating webhooks are invoked after mutating webhooks have processed the resource. These webhooks can validate the mutated object and either approve or deny the request. If the validating webhook rejects the request, the API server will not allow the resource to be created, updated, or deleted.

The `AdmissionReview` object contains the incoming request, and the response from the webhook will include the decision to either accept or reject the request. If the webhook is a **mutating webhook**, it will also include any modifications to the object in the response.

Here’s an example response structure from the webhook:

```json
{
  "response": {
    "uid": "unique-uid",
    "allowed": true,
    "patchType": "JSONPatch",
    "patch": "[{\"op\": \"add\", \"path\": \"/spec/containers/0/env\", \"value\": [{\"name\": \"MY_ENV_VAR\", \"value\": \"value\"}]}]"
  }
}
```

In this case, the webhook adds an environment variable to the first container in the pod spec before the resource is created.

### Conclusion

Custom admission controllers offer powerful flexibility in Kubernetes, enabling organizations to enforce specific rules, policies, and defaults on resources in the cluster. By writing custom admission controllers, registering them via webhooks, and deploying them to the Kubernetes API server, administrators can ensure that their clusters operate according to their unique requirements. Whether using mutating or validating webhooks, custom controllers help extend Kubernetes' default behavior to suit organizational needs.