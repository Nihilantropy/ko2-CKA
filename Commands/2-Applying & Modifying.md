## **2. Applying and Modifying Resources**

### **2.1. Applying Changes**
- **Apply changes from a YAML file (declarative approach):**  
  ```sh
  kubectl apply -f <file>.yaml
  ```
- **Apply changes to all YAML files in a directory:**  
  ```sh
  kubectl apply -f <directory>/
  ```
- **Apply changes while forcefully replacing fields not present in the new configuration:**  
  ```sh
  kubectl apply --force -f <file>.yaml
  ```
- **Apply changes and record the command in the resource’s annotation (useful for tracking changes):**  
  ```sh
  kubectl apply -f <file>.yaml --record
  ```

---

### **2.2. Replacing Resources**
- **Replace an existing resource completely (imperative approach):**  
  ```sh
  kubectl replace -f <file>.yaml
  ```
- **Force replace a resource (useful for recreating immutable fields, like volume mounts):**  
  ```sh
  kubectl replace --force -f <file>.yaml
  ```
- **Replace a ConfigMap or Secret without restarting the pods:**  
  ```sh
  kubectl create configmap <configmap-name> --from-literal=key=value --dry-run=client -o yaml | kubectl replace -f -
  ```
  ```sh
  kubectl create secret generic <secret-name> --from-literal=key=value --dry-run=client -o yaml | kubectl replace -f -
  ```

---

### **2.3. Editing Resources**
- **Edit a live resource interactively:**  
  ```sh
  kubectl edit <resource> <name>
  ```
- **Edit a resource in JSON format instead of YAML (useful for scripting modifications):**  
  ```sh
  kubectl get <resource> <name> -o json | jq '.spec.replicas=5' | kubectl apply -f -
  ```
- **Edit a deployment and trigger a rollout restart (useful when changing environment variables):**  
  ```sh
  kubectl set env deployment/<deployment-name> ENV_VAR=value
  ```

---

### **2.4. Patching Resources**
- **Patch a resource using JSON merge (modify replicas in a deployment):**  
  ```sh
  kubectl patch deployment <deployment-name> -p '{"spec": {"replicas": 3}}'
  ```
- **Patch a resource using JSON Patch syntax (modify specific field without affecting others):**  
  ```sh
  kubectl patch deployment <deployment-name> --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value": 3}]'
  ```
- **Patch a node to mark it as unschedulable (cordon a node):**  
  ```sh
  kubectl patch node <node-name> -p '{"spec": {"unschedulable": true}}'
  ```
- **Patch a running pod to modify labels dynamically:**  
  ```sh
  kubectl patch pod <pod-name> --type='merge' -p='{"metadata": {"labels": {"environment": "production"}}}'
  ```
- **Patch a service to change its type (e.g., from ClusterIP to LoadBalancer):**  
  ```sh
  kubectl patch svc <service-name> -p '{"spec": {"type": "LoadBalancer"}}'
  ```

---

### **2.5. Managing Resource Versions & Conflicts**
- **Apply changes while avoiding conflicts with concurrent modifications:**  
  ```sh
  kubectl apply -f <file>.yaml --server-side
  ```
- **Use `kubectl diff` to preview changes before applying them:**  
  ```sh
  kubectl diff -f <file>.yaml
  ```
- **Force apply a resource and override conflicting changes (use with caution!):**  
  ```sh
  kubectl apply -f <file>.yaml --force-conflicts
  ```
- **Apply a resource only if it does not already exist (useful for idempotency):**  
  ```sh
  kubectl apply --server-side --field-manager=my-manager -f <file>.yaml
  ```

---

### **2.6. Dealing with Immutable Fields**
- **Delete and recreate a resource when immutable fields (e.g., `spec.selector` in a Service) need to be changed:**  
  ```sh
  kubectl delete -f <file>.yaml && kubectl apply -f <file>.yaml
  ```
- **Modify a Persistent Volume Claim (PVC) size by deleting and recreating it (ensure data persistence is maintained):**  
  ```sh
  kubectl delete pvc <pvc-name> --wait=false
  kubectl apply -f <new-pvc-definition>.yaml
  ```

---

### **2.7. Advanced Use Cases**
- **Modify a running pod's environment variables dynamically (requires restart):**  
  ```sh
  kubectl set env deployment/<deployment-name> ENV_VAR=value
  ```
- **Modify an image of a running deployment without editing the YAML file:**  
  ```sh
  kubectl set image deployment/<deployment-name> <container-name>=<new-image>
  ```
- **Trigger a rolling update by updating an annotation (without changing the YAML definition):**  
  ```sh
  kubectl annotate deployment <deployment-name> kubernetes.io/change-cause="Updated environment variables"
  ```
- **Modify the storage class of an existing Persistent Volume Claim (requires recreation):**  
  ```sh
  kubectl patch pvc <pvc-name> -p '{"spec": {"storageClassName": "new-storage-class"}}'
  ```
