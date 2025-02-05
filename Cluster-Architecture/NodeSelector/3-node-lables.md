### 3. **Node Labels**

#### **What are Node Labels?**

Node labels are key-value pairs that are assigned to nodes in a Kubernetes cluster. These labels describe the attributes or characteristics of nodes, such as hardware specifications, roles, or locations within the infrastructure.

#### **How to Assign Labels to Nodes**

To assign labels to nodes, you can use the `kubectl label` command:

```bash
kubectl label nodes <node-name> <key>=<value>
```

For example, to label a node with the label `role=database`:

```bash
kubectl label nodes node1 role=database
```

#### **Managing Node Labels with `kubectl`**

You can view the labels of nodes using the `kubectl get nodes` command with the `--show-labels` option:

```bash
kubectl get nodes --show-labels
```

To remove a label from a node:

```bash
kubectl label nodes <node-name> <key>-
```

For example, to remove the label `role=database` from a node:

```bash
kubectl label nodes node1 role-
```

---