## **5. Kustomization File Components**  

The `kustomization.yaml` file is the heart of Kustomize. It defines how Kubernetes manifests are transformed, customized, and managed. Below are its key components.  

---

### **5.1 Resources**  

The `resources` field lists all Kubernetes manifest files that should be managed by Kustomize.  

#### **Example**  
```yaml
resources:
  - deployment.yaml
  - service.yaml
  - configmap.yaml
```
- Kustomize reads these files and applies transformations before deployment.  
- Unlike `kubectl apply -f`, this allows structured customization without modifying the original files.  

---

### **5.2 Patches**  

Patches allow modifying existing Kubernetes resources **without altering the original YAML files**. Kustomize supports two types of patches:  

#### **5.2.1 Strategic Merge Patches**  
Strategic merge patches allow partial modifications by merging changes into the original manifest.  

**Example Patch (`patch-deployment.yaml`)**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 5  # Changing replica count
```
**Applying the Patch in `kustomization.yaml`**  
```yaml
resources:
  - deployment.yaml
patchesStrategicMerge:
  - patch-deployment.yaml
```
- This patch will update **only** the specified fields while keeping other values unchanged.  

#### **5.2.2 JSON Patches**  
JSON patches are useful for fine-grained modifications. They follow the JSON Patch (RFC 6902) format.  

**Example JSON Patch (`patch-replicas.json`)**  
```json
[
  {
    "op": "replace",
    "path": "/spec/replicas",
    "value": 3
  }
]
```
**Applying the JSON Patch in `kustomization.yaml`**  
```yaml
patchesJson6902:
  - target:
      group: apps
      version: v1
      kind: Deployment
      name: my-app
    path: patch-replicas.json
```
- JSON patches provide more precise control over changes compared to strategic merge patches.  

---

### **5.3 ConfigMaps and Secrets Generation**  

Instead of manually defining ConfigMaps and Secrets, Kustomize can **dynamically generate them** from files or literals.  

#### **Generating a ConfigMap**  
**Example in `kustomization.yaml`**  
```yaml
configMapGenerator:
  - name: app-config
    files:
      - app.properties
    literals:
      - API_URL=https://api.example.com
```
This generates a ConfigMap named `app-config` with:  
- The contents of `app.properties` as key-value pairs.  
- The literal key-value `API_URL=https://api.example.com`.  

#### **Generating a Secret**  
**Example in `kustomization.yaml`**  
```yaml
secretGenerator:
  - name: app-secret
    literals:
      - DB_USER=admin
      - DB_PASS=securepass
```
This creates a Kubernetes Secret named `app-secret` with the specified credentials.  

By default, Kustomize appends a **hash suffix** to the generated ConfigMaps and Secrets to avoid stale configurations.  

---

### **5.4 Name Prefixes and Suffixes**  

Kustomize allows modifying resource names by adding **prefixes or suffixes** to prevent conflicts across environments.  

**Example in `kustomization.yaml`**  
```yaml
namePrefix: dev-
nameSuffix: -v1
```
- A Deployment named `my-app` will be transformed into `dev-my-app-v1`.  

This is useful when deploying the same application to **multiple environments** without name clashes.  

---

### **5.5 Labels and Annotations**  

Kustomize enables adding **common labels and annotations** to all resources without manually modifying each file.  

#### **Adding Labels**  
```yaml
commonLabels:
  environment: dev
  app: my-app
```
- Adds `environment=dev` and `app=my-app` to all resources.  

#### **Adding Annotations**  
```yaml
commonAnnotations:
  managed-by: kustomize
```
- Adds `managed-by=kustomize` to all resources.  

---

### **Summary**  
- **Resources** define the base YAML files.  
- **Patches** allow modifying configurations without changing original manifests.  
- **ConfigMaps and Secrets** can be dynamically generated.  
- **Name prefixes and suffixes** prevent conflicts in multi-environment deployments.  
- **Labels and annotations** improve resource organization and management.  

By leveraging these components, Kustomize provides a powerful, **declarative** way to manage Kubernetes configurations efficiently. 🚀