# **Essential Kubernetes Commands for the CKA Exam**

This guide provides a comprehensive list of essential Kubernetes commands to help you efficiently manage a cluster and prepare for the **Certified Kubernetes Administrator (CKA) exam**.

---
## **1. Creating and Managing Resources**

- **Create resources from YAML files:**
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
- **Generate YAML for a resource without applying it:**
  ```sh
  kubectl create deployment <deployment-name> --image=<image> --dry-run=client -o yaml
  ```

---
## **2. Applying and Modifying Resources**

- **Apply changes from a YAML file (declarative approach):**
  ```sh
  kubectl apply -f <file>.yaml
  ```
- **Replace an existing resource:**
  ```sh
  kubectl replace -f <file>.yaml
  ```
- **Edit a live resource interactively:**
  ```sh
  kubectl edit <resource> <name>
  ```
- **Patch a resource:**
  ```sh
  kubectl patch <resource> <name> --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value": 3}]'
  ```

---
## **3. Viewing Resources and Cluster Status**

- **List various resources:**
  ```sh
  kubectl get pods,services,deployments,nodes
  ```
- **Describe details of a specific resource:**
  ```sh
  kubectl describe <resource> <name>
  ```
- **List all resources across all namespaces:**
  ```sh
  kubectl get all --all-namespaces
  ```
- **Check cluster information:**
  ```sh
  kubectl cluster-info
  ```
- **View API resources available in the cluster:**
  ```sh
  kubectl api-resources
  ```

---
## **4. Deleting Resources**

- **Delete a specific pod:**
  ```sh
  kubectl delete pod <pod-name>
  ```
- **Delete resources using YAML definitions:**
  ```sh
  kubectl delete -f <file>.yaml
  ```
- **Delete a deployment:**
  ```sh
  kubectl delete deployment <deployment-name>
  ```
- **Delete all pods in a namespace:**
  ```sh
  kubectl delete pods --all -n <namespace>
  ```

---
## **5. Debugging and Troubleshooting**

- **View logs from a pod:**
  ```sh
  kubectl logs <pod-name>
  ```
- **Stream live logs from a pod:**
  ```sh
  kubectl logs -f <pod-name>
  ```
- **Execute commands inside a running container:**
  ```sh
  kubectl exec -it <pod-name> -- /bin/sh
  ```
- **View recent events in the cluster:**
  ```sh
  kubectl get events --sort-by='.metadata.creationTimestamp'
  ```
- **Show resource usage by pods/nodes:**
  ```sh
  kubectl top pod
  kubectl top node
  ```

---
## **6. Scaling and Rolling Updates**

- **Scale a deployment:**
  ```sh
  kubectl scale deployment <deployment-name> --replicas=<number>
  ```
- **Check rollout status of a deployment:**
  ```sh
  kubectl rollout status deployment <deployment-name>
  ```
- **Undo the last deployment update:**
  ```sh
  kubectl rollout undo deployment <deployment-name>
  ```

---
## **7. Working with Namespaces**

- **List all namespaces:**
  ```sh
  kubectl get namespaces
  ```
- **Create a new namespace:**
  ```sh
  kubectl create namespace <namespace>
  ```
- **Delete a namespace:**
  ```sh
  kubectl delete namespace <namespace>
  ```
- **Set the default namespace for the session:**
  ```sh
  kubectl config set-context --current --namespace=<namespace>
  ```

---
## **8. Networking and Service Discovery**

- **Get services in a namespace:**
  ```sh
  kubectl get svc -n <namespace>
  ```
- **Check endpoints of a service:**
  ```sh
  kubectl get endpoints <service-name>
  ```
- **Test internal communication between pods:**
  ```sh
  kubectl exec -it <pod-name> -- curl <service-name>:<port>
  ```

---
## **9. Managing Storage and Persistent Volumes**

- **View persistent volume claims (PVCs):**
  ```sh
  kubectl get pvc
  ```
- **Describe a persistent volume (PV):**
  ```sh
  kubectl describe pv <pv-name>
  ```
- **Get storage classes available in the cluster:**
  ```sh
  kubectl get storageclass
  ```

---
## **10. Managing Jobs and CronJobs**

- **Create a one-time job:**
  ```sh
  kubectl create job <job-name> --image=<image>
  ```
- **List running jobs:**
  ```sh
  kubectl get jobs
  ```
- **Create a scheduled job (CronJob):**
  ```sh
  kubectl create cronjob <cronjob-name> --image=<image> --schedule="*/5 * * * *"
  ```

---
## **11. Security and Access Control**

- **Get service accounts in a namespace:**
  ```sh
  kubectl get serviceaccount -n <namespace>
  ```
- **View role-based access control (RBAC) roles:**
  ```sh
  kubectl get roles -n <namespace>
  ```
- **Describe a role or cluster role:**
  ```sh
  kubectl describe role <role-name> -n <namespace>
  ```
- **Check pod security policies (PSP):**
  ```sh
  kubectl get psp
  ```

---
## **12. Cluster Administration Commands**

- **Check available API versions and resources:**
  ```sh
  kubectl api-versions
  kubectl api-resources
  ```
- **Drain a node before maintenance:**
  ```sh
  kubectl drain <node-name> --ignore-daemonsets
  ```
- **Mark a node as schedulable/unschedulable:**
  ```sh
  kubectl cordon <node-name>
  kubectl uncordon <node-name>
  ```
- **Check cluster component statuses:**
  ```sh
  kubectl get componentstatuses
  ```

---
## **Conclusion**

Mastering these `kubectl` commands will help you efficiently manage Kubernetes clusters and prepare for the **CKA certification exam**. Regular practice with these commands in a real or simulated cluster environment is recommended. 🚀

