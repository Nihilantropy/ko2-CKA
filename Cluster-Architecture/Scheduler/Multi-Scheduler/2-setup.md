### **2. Setting Up Multiple Schedulers in Kubernetes**  

Kubernetes allows running multiple schedulers alongside the default scheduler. This is useful when different workloads require distinct scheduling policies or optimizations.  

#### **2.1 Deploying an Additional Scheduler**  
To deploy a second scheduler in a Kubernetes cluster:  

1. **Create a Custom Scheduler Deployment**  
   - Define a new scheduler as a Kubernetes Deployment using a custom scheduler binary or modifying the existing one.  
   - Example of a custom scheduler deployment:  

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: custom-scheduler
     namespace: kube-system
   spec:
     replicas: 1
     selector:
       matchLabels:
         component: custom-scheduler
     template:
       metadata:
         labels:
           component: custom-scheduler
       spec:
         serviceAccountName: system:kube-scheduler
         containers:
           - name: custom-scheduler
             image: k8s.gcr.io/kube-scheduler:v1.28.0
             command:
               - /usr/local/bin/kube-scheduler
               - --config=/etc/kubernetes/custom-scheduler-config.yaml
               - --leader-elect=false
             volumeMounts:
               - name: config-volume
                 mountPath: /etc/kubernetes/
         volumes:
           - name: config-volume
             configMap:
               name: custom-scheduler-config
   ```

2. **Define a Custom Scheduler Configuration**  
   - Example `custom-scheduler-config.yaml`:  

   ```yaml
   apiVersion: kubescheduler.config.k8s.io/v1
   kind: KubeSchedulerConfiguration
   clientConnection:
     kubeconfig: "/etc/kubernetes/scheduler.conf"
   leaderElection:
     leaderElect: false
   ```

3. **Apply the Deployment**  
   ```sh
   kubectl apply -f custom-scheduler.yaml
   ```

#### **2.2 Assigning Pods to a Specific Scheduler**  
Once multiple schedulers are running, Pods must explicitly specify which scheduler to use.  

- In the Pod specification, add the `schedulerName` field:  

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: example-pod
  spec:
    schedulerName: custom-scheduler
    containers:
      - name: nginx
        image: nginx
  ```

- If `schedulerName` is omitted, the default Kubernetes scheduler is used.  

#### **2.3 Handling Scheduling Conflicts**  
When multiple schedulers are running, conflicts may arise if:  

- **Multiple schedulers attempt to schedule the same Pod** – This can be prevented by ensuring distinct `schedulerName` values in Pod manifests.  
- **A custom scheduler fails to schedule a Pod** – Implement fallback mechanisms or allow the default scheduler to handle unscheduled Pods.  
- **A scheduler crashes** – Kubernetes does not automatically fail over to another scheduler, so monitoring and redundancy are crucial.  

Ensuring proper scheduling policies and redundancy mechanisms helps maintain cluster stability when using multiple schedulers.