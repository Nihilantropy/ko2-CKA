# **Kubernetes Cluster Architecture**

## **1. Introduction**
A Kubernetes cluster is a collection of nodes that run containerized applications. It provides a scalable and automated environment for deploying, managing, and orchestrating containers. The cluster consists of **master (control plane) nodes** and **worker (compute) nodes** that work together to ensure high availability and efficient resource management.

---

## **2. Cluster Components**
### **2.1 Master Node (Control Plane)**
The master node is responsible for managing the entire cluster, scheduling workloads, and maintaining the desired state of applications.

#### **Core Components of the Master Node**
- **API Server (`kube-apiserver`)**
  - Acts as the front-end for Kubernetes.
  - Handles API requests from users and other cluster components.
  - Performs authentication, validation, and routing of requests.
  
- **Scheduler (`kube-scheduler`)**
  - Assigns workloads (Pods) to available worker nodes.
  - Considers factors like resource availability, node affinity, and constraints.
  
- **Controller Manager (`kube-controller-manager`)**
  - Runs controllers that ensure the cluster maintains the desired state.
  - Key controllers:
    - **Node Controller**: Monitors node health.
    - **Replication Controller**: Ensures the correct number of Pod replicas.
    - **Service Account Controller**: Manages authentication for applications.

- **etcd (Distributed Key-Value Store)**
  - Stores all cluster configuration data and state.
  - Ensures consistency and fault tolerance across nodes.
  - Uses **RAFT consensus algorithm** for distributed storage.

---

### **2.2 Worker Nodes (Compute Nodes)**
Worker nodes run application workloads assigned by the master node. Each worker node contains essential components for running and managing containers.

#### **Core Components of Worker Nodes**
- **Kubelet**
  - Agent that communicates with the master node.
  - Ensures Pods and containers are running as expected.
  - Watches for configuration changes and applies them.

- **Container Runtime**
  - Executes containers inside Pods.
  - Common runtimes: **Docker, containerd, CRI-O**.

- **Kube Proxy**
  - Manages networking and load balancing within the cluster.
  - Ensures network communication between Pods and services.
  - Implements Kubernetes Service networking rules.

---

## **3. Kubernetes Objects & Resources**
### **3.1 Pods**
- The **smallest deployable unit** in Kubernetes.
- Represents one or more containers that share the same storage and networking.
- Can have sidecar containers (e.g., logging, monitoring).

### **3.2 Services**
- Expose applications running inside Pods to other Pods or external clients.
- Types:
  - **ClusterIP** (default) – Internal access only.
  - **NodePort** – Exposes service on a static port of each node.
  - **LoadBalancer** – Uses cloud provider's load balancer.

### **3.3 Deployments**
- Manage and scale application Pods.
- Ensures the desired number of replicas are running.
- Provides rolling updates and rollbacks.

### **3.4 Namespaces**
- Logical partitions for organizing Kubernetes resources.
- Helps isolate workloads within a cluster.

---

## **4. Cluster Networking**
- **Pod-to-Pod communication** – Uses flat networking model with unique IPs per Pod.
- **Service-to-Service communication** – Uses `kube-proxy` for routing traffic.
- **Ingress Controller** – Manages external access to cluster services.
- **Network Policies** – Control how Pods communicate within the cluster.

---

## **5. Summary**
- **Master Node** manages cluster operations and maintains the desired state.
- **Worker Nodes** run application workloads inside **Pods**.
- **Key components**: API server, scheduler, controller manager, etcd, kubelet, container runtime, and kube-proxy.
- Kubernetes provides **services, deployments, namespaces, and networking policies** for managing applications.
- **Networking** ensures seamless communication between Pods and external systems.

This documentation provides an overview of **Kubernetes cluster architecture**, detailing its core components and functions. 🚀

