## **7. Troubleshooting Namespaces**  

Proper troubleshooting of namespace-related issues is essential for maintaining a stable and well-functioning Kubernetes environment. This section outlines common problems and effective debugging techniques.  

---

### **7.1 Common Issues and Fixes**  

- **Pods Not Scheduling in a Namespace**  
  - Check if the namespace exists:  
    ```sh
    kubectl get namespaces
    ```
  - Verify resource quotas and limits:  
    ```sh
    kubectl get resourcequotas -n <namespace>
    ```
  - Inspect pending pod events:  
    ```sh
    kubectl describe pod <pod-name> -n <namespace>
    ```

- **Namespace Stuck in "Terminating" State**  
  - Identify and delete any finalizers blocking deletion:  
    ```sh
    kubectl get namespace <namespace> -o json | jq '.spec.finalizers=[]' | kubectl replace --raw "/api/v1/namespaces/<namespace>/finalize" -f -
    ```

- **Access Denied Errors**  
  - Check RBAC roles and bindings for the namespace:  
    ```sh
    kubectl get rolebindings -n <namespace>
    kubectl get roles -n <namespace>
    ```

---

### **7.2 Debugging Namespace-related Problems**  

- **List All Objects in a Namespace**  
  ```sh
  kubectl get all -n <namespace>
  ```
  This command helps identify existing workloads and missing components.  

- **Check Namespace Events**  
  ```sh
  kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
  ```
  This displays recent errors or warnings affecting the namespace.  

- **Inspect Network Policies**  
  ```sh
  kubectl get networkpolicies -n <namespace>
  ```
  Ensure that policies are not unintentionally blocking communication.  

- **View Namespace Logs**  
  ```sh
  kubectl logs -l app=<app-label> -n <namespace>
  ```
  Reviewing logs can reveal issues related to application failures.  

By systematically applying these troubleshooting steps, you can efficiently diagnose and resolve namespace-related problems in your Kubernetes cluster.