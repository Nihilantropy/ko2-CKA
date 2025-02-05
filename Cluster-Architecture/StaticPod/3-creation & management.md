### **3. Creating and Managing Static Pods**

#### **Defining Static Pods in a YAML Manifest**
Static Pods are defined using a YAML manifest, similar to regular Kubernetes pods, but with the key difference that they are not created through the Kubernetes API server. Instead, the manifest is placed on the node’s file system in a specific directory that the kubelet watches. 

Here is an example of a basic static pod YAML manifest:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-pod-example
  labels:
    app: static-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
  restartPolicy: Always
```

- **`apiVersion`**: Defines the version of the API to use for the static pod, in this case, `v1`.
- **`kind`**: Specifies the object type, which is `Pod` for static pods.
- **`metadata`**: Contains the name and labels for the pod, similar to regular pods.
- **`spec`**: Describes the container(s) that run in the pod. It includes the container's name, image, ports, and the restart policy.

Once this manifest is defined, it will be placed in the specified directory on the node for the kubelet to manage.

#### **Locating Static Pod Manifests on the Node**
Static pod manifests must be placed in a directory that the kubelet monitors. By default, the kubelet watches the `/etc/kubernetes/manifests/` directory for static pod manifests. However, this location may vary depending on your Kubernetes distribution or configuration.

**Steps to create a static pod**:
1. **Prepare the manifest**: Write the pod manifest in YAML format as shown in the previous section.
2. **Place the manifest in the kubelet's directory**: Copy the YAML file to `/etc/kubernetes/manifests/` on the node where you want the pod to run. For example:
   ```bash
   sudo cp static-pod-example.yaml /etc/kubernetes/manifests/
   ```
3. **Pod Creation**: Once the manifest is placed in the directory, the kubelet will automatically detect the new manifest and create the pod on the node.

By placing the manifest in this directory, the kubelet will immediately begin managing the pod. The pod will be created, and any necessary changes will be applied automatically as the manifest is updated.

#### **Managing Static Pods via `kubectl`**
While static pods are not managed by the Kubernetes API server and do not appear in the usual `kubectl` pod listings, you can still manage and interact with them using certain commands. However, some actions are limited compared to regular pods.

1. **Viewing Static Pods**:
   - You can use `kubectl` to view static pods, but you need to specify the `--kubeconfig` and node-related options since static pods exist only on specific nodes.
   
   Example:
   ```bash
   kubectl get pod -o wide --kubeconfig=/etc/kubernetes/admin.conf
   ```
   This will show static pods in addition to regular pods on the node.

2. **Interacting with Static Pods**:
   Static pods can be inspected using `kubectl describe` and other standard commands. However, keep in mind that since they are not managed by the API server, some features such as scaling or updates will require you to manually edit the pod manifest and modify or delete the pod.

   For example:
   ```bash
   kubectl describe pod static-pod-example --kubeconfig=/etc/kubernetes/admin.conf
   ```

3. **Deleting Static Pods**:
   To delete a static pod, you must remove the manifest file from the node’s manifest directory. The kubelet will automatically detect the change and remove the pod.

   Example:
   ```bash
   sudo rm /etc/kubernetes/manifests/static-pod-example.yaml
   ```

4. **Updating Static Pods**:
   To update a static pod, modify its YAML manifest and replace the old manifest file in the manifest directory. The kubelet will notice the change and restart the pod with the new configuration.

   Example:
   ```bash
   sudo vi /etc/kubernetes/manifests/static-pod-example.yaml
   ```
   After saving the changes, the kubelet will automatically restart the pod with the updated configuration.

5. **Troubleshooting Static Pods**:
   If the static pod is not running as expected, you can check the kubelet’s logs to diagnose issues:
   ```bash
   journalctl -u kubelet
   ```

6. **Accessing Static Pod Logs**:
   Static pods can have their logs viewed with `kubectl logs`, but remember that you need to specify the node’s kubeconfig if the pod is node-specific:
   ```bash
   kubectl logs static-pod-example --kubeconfig=/etc/kubernetes/admin.conf
   ```

### **Summary**
- **Static Pod Creation**: Static pods are created by placing YAML manifests in the appropriate directory that the kubelet monitors.
- **Management**: Static pods are managed directly by the kubelet and not the Kubernetes control plane, which means they are not listed in the API server's pod management tools, but you can still interact with them via `kubectl`.
- **Deleting and Updating**: Static pods can be updated by modifying the manifest file, and they are deleted by removing the file from the node’s manifest directory.
