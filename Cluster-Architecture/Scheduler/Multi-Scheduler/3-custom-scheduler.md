### **3. Creating and Deploying a Custom Scheduler**  

A custom scheduler allows fine-tuned control over how workloads are assigned to nodes. This can be useful for specialized workloads, resource optimization, or implementing custom scheduling policies.  

#### **3.1 Writing a Basic Scheduler in Go**  

A Kubernetes scheduler interacts with the API server to watch for unscheduled Pods and assigns them to nodes based on custom logic. Below is a simplified custom scheduler written in Go:  

```go
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

func main() {
	// Connect to the Kubernetes API
	config, err := rest.InClusterConfig()
	if err != nil {
		log.Fatalf("Error creating in-cluster config: %v", err)
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalf("Error creating Kubernetes client: %v", err)
	}

	schedulerName := flag.String("scheduler-name", "custom-scheduler", "Name of the custom scheduler")
	flag.Parse()

	for {
		// List all pending Pods
		pods, err := clientset.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{
			FieldSelector: "spec.schedulerName=" + *schedulerName,
		})
		if err != nil {
			log.Printf("Error retrieving pods: %v", err)
			continue
		}

		for _, pod := range pods.Items {
			// Select a node (naive selection: first available node)
			nodes, err := clientset.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
			if err != nil || len(nodes.Items) == 0 {
				log.Printf("No available nodes for scheduling")
				continue
			}

			selectedNode := nodes.Items[0].Name

			// Bind the Pod to the selected node
			binding := &v1.Binding{
				ObjectMeta: metav1.ObjectMeta{Name: pod.Name, Namespace: pod.Namespace},
				Target:     v1.ObjectReference{Kind: "Node", Name: selectedNode},
			}

			err = clientset.CoreV1().Pods(pod.Namespace).Bind(context.TODO(), binding, metav1.CreateOptions{})
			if err != nil {
				log.Printf("Failed to bind pod %s to node %s: %v", pod.Name, selectedNode, err)
			} else {
				fmt.Printf("Scheduled pod %s on node %s\n", pod.Name, selectedNode)
			}
		}

		time.Sleep(5 * time.Second) // Adjust based on scheduling frequency needs
	}
}
```

#### **3.2 Integrating with the Kubernetes API Server**  

To integrate a custom scheduler with Kubernetes:  

1. **Compile the Scheduler**  
   ```sh
   go mod init custom-scheduler
   go mod tidy
   go build -o custom-scheduler main.go
   ```

2. **Create a Scheduler Deployment**  

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
             image: custom-scheduler:latest
             command: ["/custom-scheduler"]
             args: ["--scheduler-name=custom-scheduler"]
   ```

3. **Deploy the Custom Scheduler**  
   ```sh
   kubectl apply -f custom-scheduler.yaml
   ```

#### **3.3 Running the Custom Scheduler in a Cluster**  

- Ensure that Pods use the `schedulerName` field to be scheduled by the custom scheduler:  

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: custom-scheduled-pod
  spec:
    schedulerName: custom-scheduler
    containers:
      - name: nginx
        image: nginx
  ```

- Verify that the scheduler is running:  
  ```sh
  kubectl get pods -n kube-system | grep custom-scheduler
  ```

- Check if the custom scheduler is assigning Pods to nodes:  
  ```sh
  kubectl describe pod custom-scheduled-pod
  ```

This process enables Kubernetes to run a custom scheduling algorithm, allowing fine-grained control over workload placement and optimization.