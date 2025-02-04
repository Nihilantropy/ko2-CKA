## Common and Advanced Commands for Interacting with Pods

- **List Pods:**
```bash
kubectl get pods
```
Lists all Pods in the current namespace.

- **Describe a Pod:**
```bash
kubectl describe pod <pod-name>
```
Provides detailed information about the specified Pod.

- **Create/Update a Pod:**
```bash
kubectl apply -f <pod-file>.yaml
```
Applies the configuration in the advanced-pod.yaml file to create or update the Pod.

- **Delete a Pod:**
```bash
kubectl delete pod <pod-name>
```
Removes the specified Pod from the cluster.

- **View Logs for a Specific Container:**
```bash
kubectl logs <pod-name> -c main-container
```
Fetches logs for the 'main-container' in the specified Pod.

- **Execute a Command in a Running Pod:**
```bash
kubectl exec -it <pod-name> -- /bin/sh
```
Opens an interactive shell session inside the Pod for troubleshooting.

- **Port Forward to a Pod:**
```bash
kubectl port-forward <pod-name> 8080:8080
```
Forwards local port 8080 to port 8080 of the Pod, useful for testing the application.

- **Apply a Label to a Pod:**
```bash
kubectl label pod <pod-name> tier=backend
```
Adds or updates a label on the specified Pod.

- **Annotate a Pod:**
```bash
kubectl annotate pod <pod-name> description="This pod runs a multi-container application."
```
Adds additional metadata to the Pod in the form of an annotation.

- **Watch Pods in Real-Time:**
```bash
kubectl get pods --watch
```
Continuously monitors the Pod list in real-time as changes occur.

## Advanced Commands

- **Scale a Deployment (if Pods are managed by a Deployment):**
```bash
kubectl scale deployment <deployment-name> --replicas=5
```
Adjusts the number of replicas in a Deployment to handle varying workloads.

- **Retrieve Resource Usage Metrics:**
```bash
kubectl top pod <pod-name>
```
Displays current CPU and memory usage for the specified Pod (requires metrics server).

- **Update Environment Variables in a Pod (requires re-deployment): Edit the Pod definition (or associated Deployment) and apply changes using:**
```bash
kubectl apply -f advanced-pod.yaml
```

- **Debug a Failing Pod:**
```bash
kubectl describe pod <pod-name>
```
Review event logs and detailed information to diagnose issues.

- **Get Detailed API Information for a Pod:**
```bash
kubectl get pod <pod-name> -o yaml
```
Outputs the complete YAML configuration of the Pod for advanced troubleshooting.