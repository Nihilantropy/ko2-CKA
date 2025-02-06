## **8. Networking and Service Discovery**

### Basic Commands:

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

### Advanced Commands:

- **Get a list of all services across all namespaces:**
  ```sh
  kubectl get svc --all-namespaces
  ```

- **Describe a specific service to view detailed information:**
  ```sh
  kubectl describe svc <service-name> -n <namespace>
  ```

- **Check the status of a service in a specific namespace:**
  ```sh
  kubectl get svc <service-name> -n <namespace> -o wide
  ```

- **View the details of a pod’s network (e.g., IP addresses, ports, etc.):**
  ```sh
  kubectl describe pod <pod-name> -n <namespace>
  ```

- **View service mesh information (when using a service mesh like Istio or Linkerd):**
  ```sh
  kubectl get virtualservice -n <namespace>
  kubectl get destinationrule -n <namespace>
  ```

- **Check if a service is reachable from a pod using `nc` (netcat):**
  ```sh
  kubectl exec -it <pod-name> -- nc -zv <service-name> <port>
  ```

- **Check service discovery and DNS resolution inside a pod:**
  ```sh
  kubectl exec -it <pod-name> -- nslookup <service-name>.<namespace>.svc.cluster.local
  ```

### Real-World Command Scenarios:

- **Testing inter-service communication by hitting a service from another pod:**
  This command tests if two services (like a frontend and backend) can communicate.
  ```sh
  kubectl exec -it <frontend-pod> -- curl <backend-service-name>:<port>
  ```

- **Scaling a service up/down based on network load (manual scaling):**
  ```sh
  kubectl scale deployment <deployment-name> --replicas=<desired-replica-count> -n <namespace>
  ```

- **Viewing the internal traffic flow between pods:**
  With service mesh (e.g., Istio) enabled, you can inspect traffic between microservices for debugging or monitoring purposes.
  ```sh
  kubectl get pod <pod-name> -n <namespace> -o yaml | grep "istio-proxy"
  ```

- **Troubleshooting DNS resolution issues within Kubernetes cluster:**
  If internal DNS resolution isn't working, this can be helpful to identify the issue.
  ```sh
  kubectl exec -it <pod-name> -- dig <service-name>.<namespace>.svc.cluster.local
  ```

- **Port-forwarding for debugging service communication:**
  Use `kubectl port-forward` to forward a service’s port to your local machine for testing.
  ```sh
  kubectl port-forward svc/<service-name> <local-port>:<service-port> -n <namespace>
  ```

- **Viewing logs for service-related issues:**
  Check logs for debugging service communication errors between pods.
  ```sh
  kubectl logs <pod-name> -n <namespace> --follow
  ```

- **Inspecting Kubernetes Network Policies (to ensure correct traffic flow):**
  Network Policies define rules about which pods can communicate with each other.
  ```sh
  kubectl get netpol -n <namespace>
  kubectl describe netpol <network-policy-name> -n <namespace>
  ```

- **Check if Kubernetes Services are Load-balanced properly (Load Balancer service type):**
  You can check the external IP of a service exposed with a LoadBalancer type.
  ```sh
  kubectl get svc <service-name> -n <namespace> -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
  ```

### Troubleshooting Real-World Scenarios:

- **Service is unreachable from a pod:**
  1. Verify the pod is running.
     ```sh
     kubectl get pod <pod-name> -n <namespace>
     ```
  2. Check if the service endpoints are correctly exposed.
     ```sh
     kubectl get endpoints <service-name> -n <namespace>
     ```
  3. Ensure there are no network policies blocking communication.
     ```sh
     kubectl get netpol -n <namespace>
     ```
  4. Test network communication using `curl` or `nc`.
     ```sh
     kubectl exec -it <pod-name> -- curl <service-name>:<port>
     ```

- **Service communication errors (timeouts or 500 responses):**
  - Inspect the application logs for errors in the backend service.
    ```sh
    kubectl logs <pod-name> -n <namespace> --follow
    ```
  - If using a service mesh, check the mesh's monitoring and logs.
    ```sh
    kubectl get pods -n istio-system
    kubectl logs <pod-name> -n istio-system
    ```
