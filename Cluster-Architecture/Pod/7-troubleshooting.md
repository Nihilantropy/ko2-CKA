# 7️⃣ Managing & Troubleshooting Pods

Effectively managing and troubleshooting Pods is essential for maintaining a healthy Kubernetes cluster. This section covers key `kubectl` commands, log viewing, debugging techniques, and common errors with their fixes.

---

## 🔹 **kubectl Commands for Pods**

`kubectl` provides various commands to manage and inspect Pods. Below are some commonly used commands:

### 📌 **Basic Pod Operations**
| Command | Description |
|---------|---------------------------------------------------------------------------------------------------|
| `kubectl get pods`                                       | List all Pods in the current namespace.          |
| `kubectl get pods -A`                                    | List all Pods across all namespaces.             |
| `kubectl get pod <pod-name>`                             | Get detailed information about a specific Pod.   |
| `kubectl describe pod <pod-name>`                        | Show detailed Pod information, including events. |
| `kubectl delete pod <pod-name>`                          | Delete a specific Pod.                           |
| `kubectl delete pod --force --grace-period=0 <pod-name>` | Force delete a Pod immediately.                  |

### 📌 **Interacting with a Pod**
| Command | Description |
|---------|--------------------------------------------------------------------------------------|
| `kubectl exec -it <pod-name> -- /bin/sh`  | Open a shell session inside a Pod (if using `sh`). |
| `kubectl exec -it <pod-name> -- ls /app`  | Run a command inside a Pod.                        |
| `kubectl port-forward <pod-name> 8080:80` | Forward local port 8080 to Pod's port 80.          |

### 📌 **Scaling and Updating Pods**
| Command | Description |
|---------|-----------------------------------------------------------------------------------------------------------------|
| `kubectl scale deployment <deployment-name> --replicas=3`                     | Scale a deployment to 3 replicas.         |
| `kubectl set image deployment/<deployment-name> <container-name>=<new-image>` | Update a container image in a deployment. |

---

## 🔹 **Viewing Logs & Debugging Pods**

When a Pod behaves unexpectedly, logs can provide critical insights into the issue.

### 📌 **Viewing Pod Logs**
| Command | Description |
|---------|---------------------------------------------------------------------------------------------------|
| `kubectl logs <pod-name>`                     | Show logs of a Pod's main container.                        |
| `kubectl logs <pod-name> -f`                  | Follow logs in real-time.                                   |
| `kubectl logs <pod-name> --previous`          | View logs of a previously terminated container.             |
| `kubectl logs <pod-name> -c <container-name>` | View logs of a specific container in a multi-container Pod. |

#### **Example: Tail Logs from a Running Pod**
```sh
kubectl logs -f my-app-pod
```

### 📌 **Inspecting Pod Events**
Check Kubernetes events related to a Pod to identify failures:
```sh
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## 🔹 **Pod Debugging with Ephemeral Containers**

Ephemeral containers allow you to troubleshoot a running Pod without modifying it. Unlike regular containers, ephemeral containers are temporary and do not persist across Pod restarts.

### 📌 **Adding an Ephemeral Debugging Container**
1. Identify the problematic Pod:
   ```sh
   kubectl get pods
   ```

2. Add an ephemeral container to the Pod:
   ```sh
   kubectl debug -it <pod-name> --image=busybox --target=<container-name>
   ```
   - `--image=busybox`: Specifies the debugging image.
   - `--target=<container-name>`: Targets a specific container inside the Pod.

3. Verify the ephemeral container was added:
   ```sh
   kubectl get pod <pod-name> -o yaml
   ```

4. Remove the ephemeral container (restart the Pod to remove it):
   ```sh
   kubectl delete pod <pod-name>
   ```

---

## 🔹 **Common Pod Errors & Fixes**

Below are some common errors and solutions:

### ⚠️ **1. Pod Stuck in "ContainerCreating" State**
#### **Possible Causes**
- The node is pulling the container image, which takes time.
- Insufficient resources on the node.
- Network issues preventing image download.

#### **Fixes**
- Check Pod events:
  ```sh
  kubectl describe pod <pod-name>
  ```
- Ensure the image is available and correctly tagged.
- Check node status:
  ```sh
  kubectl get nodes
  ```
- Verify that the cluster has sufficient resources.

---

### ⚠️ **2. CrashLoopBackOff**
#### **Possible Causes**
- Application inside the container is crashing repeatedly.
- Missing environment variables or incorrect configurations.
- Insufficient memory or CPU.

#### **Fixes**
- Check logs for errors:
  ```sh
  kubectl logs <pod-name>
  ```
- Run the Pod in interactive mode to debug:
  ```sh
  kubectl exec -it <pod-name> -- /bin/sh
  ```
- If related to memory limits, adjust resource requests:
  ```yaml
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1"
  ```

---

### ⚠️ **3. ImagePullBackOff / ErrImagePull**
#### **Possible Causes**
- The specified image does not exist.
- The image registry requires authentication.
- The Kubernetes node cannot reach the image registry.

#### **Fixes**
- Verify the image exists and is accessible:
  ```sh
  kubectl describe pod <pod-name>
  ```
- If using a private registry, create a Kubernetes secret:
  ```sh
  kubectl create secret docker-registry my-secret \
    --docker-server=<REGISTRY> \
    --docker-username=<USERNAME> \
    --docker-password=<PASSWORD>
  ```
  Then reference it in the Pod:
  ```yaml
  imagePullSecrets:
    - name: my-secret
  ```

---

### ⚠️ **4. OOMKilled (Out of Memory Killed)**
#### **Possible Causes**
- The Pod exceeded its memory limit.
- The container requires more memory than allocated.

#### **Fixes**
- Check Pod status:
  ```sh
  kubectl describe pod <pod-name>
  ```
- Increase the memory limit:
  ```yaml
  resources:
    limits:
      memory: "2Gi"
  ```

---

### ⚠️ **5. Pod Stuck in "Terminating" State**
#### **Possible Causes**
- A Pod is taking too long to terminate due to hanging processes.
- Kubernetes cannot properly delete the Pod due to issues with volumes.

#### **Fixes**
- Force delete the Pod:
  ```sh
  kubectl delete pod <pod-name> --force --grace-period=0
  ```
- If the issue persists, check the node's status:
  ```sh
  kubectl get nodes
  ```

---

### ⚠️ **6. Node NotReady or Scheduling Issues**
#### **Possible Causes**
- The node is out of resources.
- Taints and tolerations are preventing scheduling.

#### **Fixes**
- Check node status:
  ```sh
  kubectl get nodes
  ```
- Remove unnecessary taints from a node:
  ```sh
  kubectl taint nodes <node-name> key=value:NoSchedule-
  ```
- Ensure the cluster has enough resources.

---

## 🎯 **Summary**
This section covered how to manage and troubleshoot Pods using `kubectl` commands, logs, debugging techniques, and solutions for common issues:

1️⃣ **Key `kubectl` Commands**: Get, describe, delete, exec, port-forward.  
2️⃣ **Viewing Logs**: Debug with `kubectl logs`, `kubectl describe pod`, and events.  
3️⃣ **Ephemeral Containers**: Temporarily attach a debugging container to a Pod.  
4️⃣ **Common Errors & Fixes**: `CrashLoopBackOff`, `ImagePullBackOff`, `OOMKilled`, and scheduling issues.  

By mastering these techniques, you can efficiently diagnose and resolve Kubernetes Pod issues.

---

## **References**

1. **kubectl Commands for Pods**
   - [Kubernetes Pods Overview](https://kubernetes.io/docs/concepts/workloads/pods/)
   - [Pod Specification - Kubernetes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.21/#pod-v1-core)
   
2. **Viewing Logs & Debugging Pods**
   - [Viewing Pod Logs](https://kubernetes.io/docs/tasks/debug/debug-cluster/debug-application/)
   - [Ephemeral Containers for Debugging](https://kubernetes.io/docs/tasks/debug/debug-cluster/ephemeral-containers/)
   
3. **Pod Errors & Fixes**
   - [Managing Resources for Containers - Kubernetes](https://kubernetes.io/docs/concepts/configuration/resource-request-limits/)
   - [Troubleshooting Kubernetes Pods](https://kubernetes.io/docs/tasks/debug/debug-cluster/debug-application/)
   
4. **Pod Termination & Force Deletion**
   - [Pod Lifecycle - Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
   - [Force Delete a Pod](https://kubernetes.io/docs/tasks/debug/debug-cluster/debug-pod-replication-controller/#force-delete-pods)

5. **Handling Node NotReady Issues**
   - [Troubleshoot Nodes](https://kubernetes.io/docs/tasks/debug/debug-cluster/debug-node-reaches-notready/)
   - [Kubernetes Node Taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
