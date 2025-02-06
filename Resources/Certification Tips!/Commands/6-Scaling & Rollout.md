## **6. Scaling and Rolling Updates**  

### **6.1. Scaling Deployments**  

- **Scale a deployment to a specific number of replicas:**  
  ```sh
  kubectl scale deployment <deployment-name> --replicas=<number>
  ```
  *(Increases or decreases the number of running pods in a deployment.)*  

- **Scale a deployment using a YAML file (declarative approach):**  
  ```sh
  kubectl apply -f deployment.yaml
  ```
  *(Ensures that the desired replica count is maintained as part of the YAML definition.)*  

- **Check the current replica count of a deployment:**  
  ```sh
  kubectl get deployment <deployment-name> -o jsonpath='{.status.replicas}'
  ```
  *(Useful to confirm that scaling changes have been applied.)*  

- **Scale a stateful set (ensuring ordered scaling and deletion):**  
  ```sh
  kubectl scale statefulset <statefulset-name> --replicas=<number>
  ```
  *(Ensures that pods in a StatefulSet scale in a controlled, sequential manner.)*  

- **Automatically scale based on CPU utilization (Horizontal Pod Autoscaler - HPA):**  
  ```sh
  kubectl autoscale deployment <deployment-name> --cpu-percent=50 --min=2 --max=10
  ```
  *(Automatically adjusts the number of replicas between `2` and `10` based on CPU usage.)*  

- **View the status of an autoscaler:**  
  ```sh
  kubectl get hpa
  ```
  *(Lists all active horizontal pod autoscalers in the cluster.)*  

---

### **6.2. Rolling Updates**  

- **Trigger a rolling update by changing the image of a deployment:**  
  ```sh
  kubectl set image deployment/<deployment-name> <container-name>=<new-image>:<tag>
  ```
  *(Ensures zero-downtime updates by gradually rolling out the new version.)*  

- **Check the rollout status of a deployment:**  
  ```sh
  kubectl rollout status deployment <deployment-name>
  ```
  *(Shows progress updates about how many pods have been updated.)*  

- **Pause a rolling update:**  
  ```sh
  kubectl rollout pause deployment <deployment-name>
  ```
  *(Stops an ongoing deployment rollout, allowing manual verification before continuing.)*  

- **Resume a paused rolling update:**  
  ```sh
  kubectl rollout resume deployment <deployment-name>
  ```
  *(Resumes a paused rollout.)*  

- **Perform a controlled rollout by setting a max unavailable and surge limit:**  
  ```yaml
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 2
  ```
  *(Ensures that only `1` pod becomes unavailable at a time while up to `2` additional pods can be created.)*  

- **View the history of previous deployments:**  
  ```sh
  kubectl rollout history deployment <deployment-name>
  ```
  *(Lists previous versions of the deployment for rollback purposes.)*  

---

### **6.3. Rolling Back Deployments**  

- **Undo the last deployment update:**  
  ```sh
  kubectl rollout undo deployment <deployment-name>
  ```
  *(Rolls back the deployment to the previous version in case of issues.)*  

- **Roll back to a specific revision of a deployment:**  
  ```sh
  kubectl rollout undo deployment <deployment-name> --to-revision=<revision-number>
  ```
  *(Useful if multiple versions exist, and you want to roll back to a known good version.)*  

- **Check detailed history of previous revisions (to find a stable rollback target):**  
  ```sh
  kubectl rollout history deployment <deployment-name> --revision=<revision-number>
  ```
  *(Displays details of a specific revision.)*  

- **Rollback with zero downtime by reducing termination duration:**  
  ```yaml
  spec:
    template:
      spec:
        terminationGracePeriodSeconds: 5
  ```
  *(Reduces the default termination wait time from `30` seconds to `5`, allowing a faster rollback.)*  

---

### **6.4. Handling Edge Cases and Failures**  

🔹 **Scenario 1: Fixing a stuck rollout (e.g., image pull failure)**  
```sh
kubectl rollout status deployment <deployment-name>
kubectl describe pod <pod-name> | grep -i 'ErrImagePull'
```
*(If an incorrect image was deployed, update it and retry.)*  

🔹 **Scenario 2: Preventing cascading rollouts in large clusters**  
```yaml
spec:
  progressDeadlineSeconds: 600
```
*(Prevents Kubernetes from rolling out updates indefinitely by setting a time limit.)*  

🔹 **Scenario 3: Manually scaling down and then rolling back**  
```sh
kubectl scale deployment <deployment-name> --replicas=0
kubectl rollout undo deployment <deployment-name>
kubectl scale deployment <deployment-name> --replicas=5
```
*(A forced rollback strategy when pods become unresponsive.)*  

🔹 **Scenario 4: Performing a canary deployment to test a new version**  
```yaml
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```
*(Ensures that only one new pod is added at a time to monitor for issues before rolling out further.)*  
