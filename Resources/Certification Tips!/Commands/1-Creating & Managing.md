## **1. Creating and Managing Resources**

### **1.1. Creating Resources**
- **Create resources from a YAML file:**
  ```sh
  kubectl create -f <file>.yaml
  ```
- **Run a pod using an image:**
  ```sh
  kubectl run <pod-name> --image=<image>
  ```
- **Expose a pod as a service:**
  ```sh
  kubectl expose pod <pod-name> --port=<port> --target-port=<port>
  ```
- **Create a deployment with multiple replicas:**
  ```sh
  kubectl create deployment <deployment-name> --image=<image> --replicas=<num>
  ```
- **Generate a YAML file for a resource without applying it:**
  ```sh
  kubectl create deployment <deployment-name> --image=<image> --dry-run=client -o yaml
  ```

---

### **1.2. Creating Advanced Resources**
- **Create a pod with specific labels:**
  ```sh
  kubectl run <pod-name> --image=<image> --labels="env=dev,app=myapp"
  ```
- **Create a service from the command line:**
  ```sh
  kubectl expose deployment <deployment-name> --type=ClusterIP --port=80 --target-port=8080
  ```
- **Create a ConfigMap from a literal value:**
  ```sh
  kubectl create configmap <configmap-name> --from-literal=key1=value1 --from-literal=key2=value2
  ```
- **Create a ConfigMap from an environment file:**
  ```sh
  kubectl create configmap <configmap-name> --from-env-file=<env-file>
  ```
- **Create a Secret from command line:**
  ```sh
  kubectl create secret generic <secret-name> --from-literal=username=admin --from-literal=password=supersecret
  ```
- **Create a Job that runs a one-time task:**
  ```sh
  kubectl create job <job-name> --image=<image>
  ```
- **Create a CronJob that runs at a specific schedule (e.g., every 5 minutes):**
  ```sh
  kubectl create cronjob <cronjob-name> --image=<image> --schedule="*/5 * * * *"
  ```

---

### **1.3. Edge Cases & Useful Flags**
- **Create a resource but wait for it to be ready:**
  ```sh
  kubectl wait --for=condition=available deployment/<deployment-name> --timeout=60s
  ```
- **Force delete a pod that is stuck in a terminating state:**
  ```sh
  kubectl delete pod <pod-name> --grace-period=0 --force
  ```
- **Create a pod that runs in a specific namespace:**
  ```sh
  kubectl run <pod-name> --image=<image> -n <namespace>
  ```
- **Create a deployment with a custom restart policy (Never or OnFailure):**
  ```sh
  kubectl run <pod-name> --image=<image> --restart=Never
  ```
- **Create a Pod that has an interactive terminal:**
  ```sh
  kubectl run -i --tty <pod-name> --image=<image> -- /bin/bash
  ```

---

### **1.4. YAML Generation & Resource Editing**
- **Generate YAML without creating the resource (useful for modifying before applying):**
  ```sh
  kubectl create deployment <deployment-name> --image=<image> --dry-run=client -o yaml > deployment.yaml
  ```
- **Generate a service YAML from an existing deployment:**
  ```sh
  kubectl expose deployment <deployment-name> --port=80 --target-port=8080 --dry-run=client -o yaml > service.yaml
  ```
- **Edit an existing resource in real-time using an interactive editor:**
  ```sh
  kubectl edit deployment <deployment-name>
  ```
