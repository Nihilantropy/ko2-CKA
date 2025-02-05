### 7. **Troubleshooting NodeSelector**

#### **Common Issues and Misconfigurations**

- **Pods not being scheduled**: If a Pod is not being scheduled, check if the node labels are correctly assigned and if the `nodeSelector` is defined properly. The Pod may not be placed if no matching node is available.
- **Incorrect label matching**: NodeSelector requires an exact match between the key-value pairs. Double-check the node labels and `nodeSelector` to ensure they align.

#### **Using `kubectl describe` for Debugging NodeSelector Problems**

You can inspect the scheduling details of a Pod using:

```bash
kubectl describe pod <pod-name>
```

Look for the **Node-Selectors** field to confirm whether the node selector is correctly matching the labels of the available nodes.

#### **Verifying Node Selector Matching with `kubectl get nodes`**

You can verify whether the nodes have the correct labels using:

```bash
kubectl get nodes --show-labels
```

Ensure that the nodes you expect to be eligible for scheduling are correctly labeled.
