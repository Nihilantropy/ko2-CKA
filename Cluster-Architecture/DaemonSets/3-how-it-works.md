### **3. How DaemonSets Work**

#### **Pod Scheduling Behavior**
DaemonSets ensure that Pods are scheduled on nodes in a Kubernetes cluster according to the specified criteria. The core function of a DaemonSet is to ensure that one Pod is created on every node (or a selected set of nodes) in the cluster.

- **Automatic Scheduling**: When a DaemonSet is created, Kubernetes automatically schedules Pods on all available nodes in the cluster that meet the selection criteria specified in the DaemonSet’s specification.
- **Dynamic Scheduling**: When new nodes are added to the cluster, the DaemonSet automatically schedules the Pods to be created on these newly added nodes without the need for additional configuration.
- **Pod Lifecycle**: Each Pod in a DaemonSet has the same lifecycle, and it is scheduled to run as long as the node is part of the cluster and the DaemonSet exists. If the DaemonSet is deleted, the Pods on each node are also deleted.

The **scheduler** in Kubernetes is responsible for ensuring that the Pods are placed according to the DaemonSet’s specifications. It takes into account the available resources on each node, the number of Pods already scheduled, and the affinity rules or taints configured for the nodes.

#### **How DaemonSets Ensure Pods Run on All or Selected Nodes**
DaemonSets are designed to place Pods on nodes in one of the following ways:

1. **All Nodes**:
   By default, a DaemonSet schedules one Pod per node across all nodes in the cluster. This ensures that the specific workload, such as a logging agent or monitoring daemon, runs on every node in the cluster.

2. **Selected Nodes**:
   It is possible to limit the DaemonSet's Pod placement to a specific subset of nodes in the cluster using the following strategies:
   - **Node Selector**: You can use a node selector to restrict the DaemonSet to only deploy Pods on nodes with specific labels. This is useful when you want Pods to run on nodes that match certain criteria, such as hardware capabilities or geographic location.
   - **Node Affinity**: You can further fine-tune scheduling by using node affinity, which allows you to express more complex rules for scheduling Pods based on node labels.
   - **Tolerations**: DaemonSets can be restricted to only run Pods on nodes with specific taints by configuring tolerations. If a node has a taint, only Pods that match the corresponding toleration will be scheduled on that node.

This level of control ensures that DaemonSets can be deployed selectively, whether for managing workloads across the entire cluster or limiting them to particular nodes (e.g., for specialized workloads or regional control).

#### **Node Affinity and Tolerations in DaemonSets**
Node Affinity and Tolerations are essential features that help in controlling the placement of DaemonSet Pods on nodes. They offer a more refined approach to ensure Pods are deployed only on nodes that satisfy specific requirements.

1. **Node Affinity**:
   Node affinity is a set of rules that determines where Pods should be scheduled based on the labels on nodes. It is expressed in the `affinity` field of the Pod specification within the DaemonSet’s Pod template. 

   - **Required Node Affinity**: Specifies hard constraints that must be met for a Pod to be scheduled on a node. If the constraints are not satisfied, the Pod will not be scheduled on that node.
   - **Preferred Node Affinity**: Specifies soft constraints. If the preferred affinity conditions are met, the Pod is scheduled accordingly, but if they are not, the scheduler will still attempt to schedule the Pod on a node that meets other criteria.

   Example of node affinity in a DaemonSet:

   ```yaml
   spec:
     template:
       spec:
         affinity:
           nodeAffinity:
             requiredDuringSchedulingIgnoredDuringExecution:
               nodeSelectorTerms:
                 - matchExpressions:
                     - key: "disktype"
                       operator: In
                       values:
                         - "ssd"
   ```

   In this example, the DaemonSet Pods will only be scheduled on nodes that have a label `disktype=ssd`.

2. **Tolerations**:
   Tolerations are used in conjunction with taints to allow DaemonSet Pods to be scheduled on nodes with specific taints. A taint is a property of a node that prevents Pods from being scheduled onto it unless the Pod has a matching toleration.

   - **Tolerations** allow Pods to “tolerate” taints and be scheduled on nodes that otherwise would not accept the Pod.

   Example of a toleration in a DaemonSet:

   ```yaml
   spec:
     template:
       spec:
         tolerations:
           - key: "special-taint"
             operator: "Equal"
             value: "true"
             effect: "NoSchedule"
   ```

   In this example, the DaemonSet Pods can be scheduled on nodes that have the `special-taint=true` taint, where other Pods without the matching toleration would be excluded.

#### **Summary**
DaemonSets are powerful controllers that ensure Pods are scheduled on nodes across the cluster, based on node affinity, tolerations, and other scheduling constraints. They provide flexibility in deploying workloads that need to run on every node or a subset of nodes in a cluster, such as logging agents, monitoring tools, and network daemons. By leveraging **node affinity** and **tolerations**, DaemonSets can be customized to fit complex scheduling needs, ensuring efficient and targeted Pod placement across your Kubernetes environment.