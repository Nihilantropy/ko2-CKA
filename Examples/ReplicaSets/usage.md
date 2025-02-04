## Common and Advanced Commands for Interacting with ReplicaSets

- **List Replicasets**
```bash
kubectl get replicasets
```

- **Create Replicasets**
```bash
kubectl create -f <replicaset-filename>.yaml
```

- **Update Replicasets modifying the replicas value**
```bash
kubectl replace -f <replicaset-filename>.yaml
```

- **Update Replicasets using cli**
```bash
kubectl scale --replicas=6 -f <replicaset-filename>.yaml

kubectl scale --replicas=6 replicaset <metadata-name-of-the-replicaset> #this won't update the .yaml file
```

- **Delete Replicasets**
```bash
kubectl delete replicaset <metadata-name-of-the-replicaset>
```

- **Edit existing Replicaset**
```bash
kubectl edit replicaset <metadata-name-of-the-replicaset>
```
This will open the .yaml configuration file of the replicaset. To make sure the replicaset has effect, the old pods needs to be deleted.