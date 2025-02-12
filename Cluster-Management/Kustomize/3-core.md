## **3. Core Concepts**  

### **3.1 What is Kustomization?**  
Kustomization is a **declarative way to manage Kubernetes configurations** using overlays and transformations instead of modifying the original YAML files. It enables users to **customize** Kubernetes resource manifests without needing a separate templating engine.  

With Kustomize, you can:  
- Define **base** Kubernetes resources (e.g., Deployments, Services, ConfigMaps).  
- Apply **overlays** to customize these resources for different environments (e.g., dev, staging, production).  
- Use **patches** to modify fields without duplicating entire files.  
- Dynamically generate **ConfigMaps and Secrets**.  

Kustomize is built into `kubectl`, making it an essential tool for managing Kubernetes configurations **natively**.  

---

### **3.2 Kustomization Directory Structure**  
A typical Kustomize project follows a structured directory layout:  

```
kustomize-example/
│── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── kustomization.yaml
│── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   ├── patch-deployment.yaml
│   ├── prod/
│   │   ├── kustomization.yaml
│   │   ├── patch-deployment.yaml
```

- **Base (`base/`)**: Contains common Kubernetes resources shared across environments.  
- **Overlays (`overlays/`)**: Defines customizations for different environments (e.g., dev, prod).  
- **kustomization.yaml**: The core Kustomize file that defines how resources are transformed.  

---

### **3.3 The `kustomization.yaml` File**  
The `kustomization.yaml` file is the configuration file used by Kustomize to define transformations, overlays, and resource modifications.  

**Basic Example (`base/kustomization.yaml`)**:  
```yaml
resources:
  - deployment.yaml
  - service.yaml
```
This defines a **base kustomization** that includes a Deployment and Service.  

**Overlay Example (`overlays/dev/kustomization.yaml`)**:  
```yaml
bases:
  - ../../base
patchesStrategicMerge:
  - patch-deployment.yaml
```
This overlay modifies the base deployment **without duplicating YAML files**.  

---

### **3.4 Bases and Overlays**  
**Bases** and **Overlays** are core components of Kustomize for managing **multi-environment Kubernetes configurations**.  

#### **Base (`base/`)**  
- Contains **common** Kubernetes configurations.  
- Should not include environment-specific values.  
- Reused across multiple overlays.  

Example (`base/kustomization.yaml`):  
```yaml
resources:
  - deployment.yaml
  - service.yaml
```

#### **Overlays (`overlays/`)**  
- Customizes the **base** configurations for different environments.  
- Uses **patches** to modify only the necessary fields.  

Example (`overlays/dev/patch-deployment.yaml`):  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2  # Overrides the base deployment's replica count
```

By using bases and overlays, **reusability** and **maintainability** of Kubernetes configurations improve significantly.  

---

### **3.5 Transformers and Generators**  
Kustomize provides **transformers** and **generators** to modify and generate resources dynamically.  

#### **Transformers**  
Transformers modify existing resources **without directly changing YAML files**.  
Examples of transformers:  
- **Labels Transformer** (adds labels to all resources)  
- **Name Prefix Transformer** (adds a prefix to resource names)  
- **Annotations Transformer** (adds annotations)  

Example (`kustomization.yaml`):  
```yaml
namePrefix: dev-
commonLabels:
  environment: dev
```
This adds a `dev-` prefix to all resources and assigns the label `environment=dev`.  

#### **Generators**  
Generators create **ConfigMaps and Secrets** dynamically from files or literals.  

Example (`kustomization.yaml`):  
```yaml
configMapGenerator:
  - name: app-config
    files:
      - config.properties
secretGenerator:
  - name: app-secret
    literals:
      - DB_USER=admin
      - DB_PASS=securepass
```
This creates a **ConfigMap and Secret** dynamically, reducing hardcoded values in YAML files.  

---

Kustomize’s core concepts provide a **flexible, declarative** way to manage Kubernetes configurations **without modifying original files**, ensuring better maintainability and scalability. 🚀