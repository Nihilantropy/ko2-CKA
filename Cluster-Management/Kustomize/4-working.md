## **4. Working with Kustomize**  

### **4.1 Creating a Kustomization**  
To start using Kustomize, you need to create a `kustomization.yaml` file inside a directory that will hold your Kubernetes manifests.  

#### **Steps to create a new Kustomization**  
1. **Create a new directory**:  
   ```sh
   mkdir my-kustomization && cd my-kustomization
   ```

2. **Add Kubernetes resource files** (e.g., `deployment.yaml`, `service.yaml`):  
   ```sh
   touch deployment.yaml service.yaml
   ```

3. **Generate a `kustomization.yaml` file**:  
   ```sh
   kustomize create --resources deployment.yaml,service.yaml
   ```
   This automatically generates a `kustomization.yaml` file with the specified resources.  

4. **Verify the created `kustomization.yaml`**:  
   ```sh
   cat kustomization.yaml
   ```

**Example `kustomization.yaml` File**  
```yaml
resources:
  - deployment.yaml
  - service.yaml
```

---

### **4.2 Applying Kustomizations**  
After defining a `kustomization.yaml` file, you can apply it to your Kubernetes cluster.  

#### **Applying a Kustomization using `kubectl`**  
```sh
kubectl apply -k .
```
- `-k` tells `kubectl` to use Kustomize.  
- The `.` refers to the current directory containing the `kustomization.yaml` file.  

#### **Example Output**  
```
deployment.apps/my-app created
service/my-service created
```

To apply an overlay (e.g., `overlays/dev`):  
```sh
kubectl apply -k overlays/dev
```

---

### **4.3 Editing Kustomizations**  
You can modify Kustomizations by adding **patches**, **labels**, **name prefixes**, or **generated resources**.  

#### **Adding a Label to All Resources**  
```yaml
commonLabels:
  environment: staging
```
Now all resources will have `environment=staging` added automatically.  

#### **Changing Resource Names with a Prefix**  
```yaml
namePrefix: staging-
```
This will rename all resources (e.g., `deployment.yaml` → `staging-deployment`).  

#### **Patching an Existing Resource**  
You can modify a resource using **patches** without altering the original manifest.  

Example patch (`patch-deployment.yaml`):  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3  # Change the number of replicas
```
Then, reference the patch in `kustomization.yaml`:  
```yaml
patchesStrategicMerge:
  - patch-deployment.yaml
```

---

### **4.4 Viewing Transformed Manifests**  
Before applying a Kustomization, you can preview the transformed YAML output using `kustomize build`.  

#### **Command to View Transformed YAML**  
```sh
kustomize build .
```
This outputs the final Kubernetes manifests with all transformations applied.  

#### **Example Output**  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: staging-my-app
  labels:
    environment: staging
spec:
  replicas: 3
---
apiVersion: v1
kind: Service
metadata:
  name: staging-my-service
  labels:
    environment: staging
```
This allows you to verify changes **before applying them** to a Kubernetes cluster.  

Alternatively, you can use `kubectl kustomize`:  
```sh
kubectl kustomize .
```
This command works similarly but is integrated within `kubectl`.  

---

By following these steps, you can efficiently create, modify, and apply Kustomizations to manage Kubernetes configurations in a structured and reusable way. 🚀