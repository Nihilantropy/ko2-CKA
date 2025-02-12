## **9. Troubleshooting**  

This section provides guidance on identifying and resolving issues when working with Kustomize. Topics include debugging techniques, common errors, verifying rendered manifests, and ensuring ConfigMaps and Secrets are correctly generated.  

---

### **9.1 Debugging Kustomizations**  

When something doesn’t work as expected, follow these debugging steps:  

#### **1. Use `kustomize build` to Inspect Output**  
Before applying a Kustomization, check how Kustomize renders the final YAML manifests:  
```sh
kustomize build overlays/dev
```
If there are missing or incorrect resources, verify the `kustomization.yaml` configuration.  

#### **2. Validate Kubernetes Manifests with `kubectl apply --dry-run=client`**  
To check for syntax errors or missing fields before applying:  
```sh
kustomize build overlays/dev | kubectl apply --dry-run=client -f -
```
This helps catch **invalid configurations** before deployment.  

#### **3. Check Logs for Errors**  
If Kustomized resources don’t behave as expected, inspect their logs:  
```sh
kubectl logs -l app=my-app -n dev
```
Replace `app=my-app` with the appropriate label selector.  

---

### **9.2 Common Issues and Fixes**  

| **Issue**                            | **Possible Cause**                         | **Solution**                                |
|--------------------------------------|--------------------------------------------|--------------------------------------------|
| **"Error: no matches for kind X"**   | Incorrect API version in the manifest.    | Verify the API version using `kubectl api-resources`. |
| **Changes not reflected after apply** | Kustomization was not built correctly.    | Run `kustomize build overlays/dev` and verify output. |
| **Secret/ConfigMap not found**       | Missing `generatorOptions: disableNameSuffixHash`. | Add `generatorOptions` to `kustomization.yaml` to disable name suffix hash. |
| **Deployment failing due to missing env variable** | ConfigMap or Secret not applied before Deployment. | Apply resources in order: `kubectl apply -k overlays/dev --prune`. |

---

### **9.3 Checking Rendered Manifests**  

To verify that Kustomize correctly applies patches and transformations:  
```sh
kustomize build overlays/staging > output.yaml
cat output.yaml
```
This outputs the final manifest, allowing you to manually inspect it before deployment.  

You can also validate against Kubernetes API schemas:  
```sh
kustomize build overlays/staging | kubeval
```
Install `kubeval` if needed:  
```sh
brew install kubeval  # macOS  
```
or  
```sh
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64 -O /usr/local/bin/kubeval && chmod +x /usr/local/bin/kubeval
```

---

### **9.4 Verifying ConfigMaps and Secrets**  

#### **1. List Generated ConfigMaps and Secrets**  
```sh
kubectl get configmap,secret -n dev
```

#### **2. Inspect ConfigMap Contents**  
```sh
kubectl describe configmap my-config -n dev
```

#### **3. Decode and View Secrets** (Base64 encoded)  
```sh
kubectl get secret my-secret -n dev -o yaml
kubectl get secret my-secret -n dev -o jsonpath="{.data.password}" | base64 --decode
```

#### **4. Ensure ConfigMaps and Secrets are Mounted Correctly**  
If a Pod fails due to missing configuration:  
```sh
kubectl exec -it my-pod -n dev -- cat /etc/config/my-config-file
```
If the file is missing, verify that the correct `volumeMounts` are defined in your `Deployment` manifest.  

---

### **Summary**  
✅ **Check rendered manifests before applying (`kustomize build`).**  
✅ **Use `kubectl apply --dry-run=client` to validate YAML syntax.**  
✅ **Verify generated ConfigMaps and Secrets (`kubectl get configmap,secret`).**  
✅ **Inspect logs for runtime errors (`kubectl logs`).**  
✅ **Ensure proper ordering of resource application.**  

Following these troubleshooting steps helps quickly diagnose and resolve Kustomize-related issues. 🚀