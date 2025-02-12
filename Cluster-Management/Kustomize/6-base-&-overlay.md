## **6. Bases and Overlays**  

Kustomize uses **bases** and **overlays** to help manage configurations for different environments (e.g., development, staging, production). This structure enables reusable, maintainable, and scalable Kubernetes configurations.  

---

### **6.1 Understanding Bases and Overlays**  

#### **What is a Base?**  
A **base** is a **common set of Kubernetes manifests** that serve as a foundation for different environments. Bases typically contain:  
- **Deployments**
- **Services**
- **ConfigMaps**
- **Secrets**  

#### **What is an Overlay?**  
An **overlay** is a **customization layer** that modifies a base for a specific environment. Overlays contain:  
- **Patches for modifications**  
- **Environment-specific configurations**  
- **Resource additions or overrides**  

**Example Directory Structure**  
```
kustomize-project/
│── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   ├── patch-replicas.yaml
│   │   ├── configmap-dev.yaml
│   │
│   ├── staging/
│   │   ├── kustomization.yaml
│   │   ├── patch-resources.yaml
│   │
│   ├── production/
│       ├── kustomization.yaml
│       ├── patch-resources.yaml
```
- **`base/`** → Common Kubernetes manifests.  
- **`overlays/dev/`** → Customizations for the development environment.  
- **`overlays/staging/`** → Staging-specific changes.  
- **`overlays/production/`** → Production-specific settings.  

---

### **6.2 Creating and Using Bases**  

A **base** consists of standard Kubernetes YAML manifests and a `kustomization.yaml` file.

#### **1. Create the Base Directory**  
```sh
mkdir -p kustomize-project/base
cd kustomize-project/base
```

#### **2. Create a Deployment (`deployment.yaml`)**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: my-app:v1
          ports:
            - containerPort: 80
```

#### **3. Create a Service (`service.yaml`)**  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

#### **4. Define the Base `kustomization.yaml`**  
```yaml
resources:
  - deployment.yaml
  - service.yaml
```

---

### **6.3 Creating and Using Overlays**  

An **overlay** customizes a base using patches or additional configuration.

#### **1. Create an Overlay Directory**  
```sh
mkdir -p kustomize-project/overlays/dev
cd kustomize-project/overlays/dev
```

#### **2. Patch for Dev (`patch-replicas.yaml`)**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
```
- This **modifies** the number of replicas for the development environment.

#### **3. Dev-Specific ConfigMap (`configmap-dev.yaml`)**  
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: "debug"
```

#### **4. Define the Overlay `kustomization.yaml`**  
```yaml
resources:
  - ../../base
  - configmap-dev.yaml

patchesStrategicMerge:
  - patch-replicas.yaml
```
- `../../base` → Inherits the base configurations.  
- `configmap-dev.yaml` → Adds a new ConfigMap.  
- `patch-replicas.yaml` → Overrides the replica count.  

---

### **6.4 Managing Multiple Environments (dev, staging, production)**  

#### **Applying the Dev Environment**  
```sh
kubectl apply -k overlays/dev
```

#### **Applying the Staging Environment**  
```sh
kubectl apply -k overlays/staging
```

#### **Applying the Production Environment**  
```sh
kubectl apply -k overlays/production
```

---

### **Summary**  
- **Bases** provide reusable configurations.  
- **Overlays** allow modifications for specific environments.  
- **Patches** enable environment-specific overrides.  
- **`kubectl apply -k overlays/dev`** applies Kustomize transformations.  

Using **bases and overlays**, you can efficiently manage multi-environment Kubernetes deployments with **clean, maintainable configurations**. 🚀