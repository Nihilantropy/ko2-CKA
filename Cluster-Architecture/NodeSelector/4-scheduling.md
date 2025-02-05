### 4. **Scheduling Pods with NodeSelector**

#### **How Kubernetes Schedules Pods Using NodeSelector**

When you define a `nodeSelector` in a Pod spec, Kubernetes schedules the Pod on nodes whose labels match the key-value pairs specified in the selector. Kubernetes compares the labels of nodes with the `nodeSelector` values. If there is a match, the Pod is scheduled on that node. If no match is found, the Pod will not be scheduled until a matching node becomes available.

#### **How NodeSelector Filters Nodes for Pod Placement**

NodeSelector filters nodes based on the exact match of key-value pairs in the Pod specification. It does not allow for more advanced matching, such as regular expressions or ranges. Only nodes with matching labels will be considered.

For example, if you specify `nodeSelector: {role: database}`, only nodes labeled with `role=database` will be eligible for Pod placement.
