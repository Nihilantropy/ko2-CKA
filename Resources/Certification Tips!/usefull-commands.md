Here is a list of useful `kubectl` commands to help manage a Kubernetes cluster, categorized for better clarity:

---

### **1. Creating and Managing Resources**
- `kubectl create -f <file>.yaml` – Create a resource from a YAML file.  
- `kubectl run <pod-name> --image=<image>` – Create a pod using an image.  
- `kubectl expose pod <pod-name> --port=<port> --target-port=<port>` – Expose a pod as a service.  

---

### **2. Applying and Modifying Resources**
- `kubectl apply -f <file>.yaml` – Apply changes to a resource from a YAML file (declarative).  
- `kubectl replace -f <file>.yaml` – Replace an existing resource with a new definition.  
- `kubectl edit <resource> <name>` – Edit a live resource (opens in default text editor).  

---

### **3. Viewing Resources and Cluster Status**
- `kubectl get pods` – List all pods.  
- `kubectl get services` – List all services.  
- `kubectl get deployments` – List all deployments.  
- `kubectl get nodes` – Show available nodes in the cluster.  
- `kubectl describe <resource> <name>` – Get detailed information about a resource.  
- `kubectl get all --all-namespaces` – View all resources across all namespaces.  

---

### **4. Deleting Resources**
- `kubectl delete pod <pod-name>` – Delete a specific pod.  
- `kubectl delete -f <file>.yaml` – Delete a resource using a YAML definition.  
- `kubectl delete deployment <deployment-name>` – Delete a deployment.  
- `kubectl delete service <service-name>` – Delete a service.  

---

### **5. Debugging and Troubleshooting**
- `kubectl logs <pod-name>` – View logs from a pod.  
- `kubectl logs -f <pod-name>` – Stream pod logs in real time.  
- `kubectl exec -it <pod-name> -- /bin/sh` – Open a shell inside a pod.  
- `kubectl get events` – View cluster events.  
- `kubectl top pod` – Show resource usage by pods.  
- `kubectl top node` – Show resource usage by nodes.  

---

### **6. Scaling and Rolling Updates**
- `kubectl scale deployment <deployment-name> --replicas=<number>` – Scale replicas of a deployment.  
- `kubectl rollout status deployment <deployment-name>` – Check the rollout status.  
- `kubectl rollout undo deployment <deployment-name>` – Roll back to the previous deployment version.  

---

### **7. Working with Namespaces**
- `kubectl get namespaces` – List all namespaces.  
- `kubectl create namespace <namespace>` – Create a new namespace.  
- `kubectl delete namespace <namespace>` – Delete a namespace.  
- `kubectl config set-context --current --namespace=<namespace>` – Set default namespace for the session.  

---

Would you like me to expand on any specific section? 🚀