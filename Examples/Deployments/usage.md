## Common and Advanced Commands for Interacting with Deployments

- **List Deployments**
```bash
kubectl get deployment
```

- **Create Deployments**
```bash
kubectl create -f <deployment-filename>.yaml
```

- **Create Deployments yaml by CLI**
```bash
kubectl create deployment --image=<image> "<other-options>" --dry-run=client'#(to prevent server creation)' -o yaml > <yaml-file-name>.yaml
```