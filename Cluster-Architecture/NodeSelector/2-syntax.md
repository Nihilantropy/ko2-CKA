### 2. **Understanding NodeSelector Syntax**

#### **Structure of NodeSelector in Pod Specification**

NodeSelector is defined in the Pod specification under the `nodeSelector` field. The `nodeSelector` field contains a set of key-value pairs, where the keys represent node labels and the values represent the desired value for those labels.

Here is the syntax for using NodeSelector in a Pod definition:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  nodeSelector:
    key1: value1
    key2: value2
  containers:
  - name: example-container
    image: example-image
```

#### **Key-Value Pair Format**

- **Key**: The label key assigned to a node, which could represent a hardware specification (e.g., `gpu`, `high-memory`), a role (e.g., `worker`, `database`), or any other custom attribute you wish to use for filtering nodes.
- **Value**: The value associated with the key. This could represent a specific configuration or state that you want to match when scheduling the Pod.

#### **Example of Using NodeSelector in a Pod Spec**

Here’s an example where a Pod is scheduled only on nodes labeled with `role: database` and `environment: production`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
spec:
  nodeSelector:
    role: database
    environment: production
  containers:
  - name: db-container
    image: db-image
```

In this case, Kubernetes will only schedule the Pod on nodes that have the labels `role=database` and `environment=production`.
