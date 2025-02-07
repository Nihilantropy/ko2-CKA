https://kubernetes.io/docs/concepts/overview/kubernetes-api/

Here is a link to kubernetes documentation if you want to learn more about this topic (You don't need it for the exam though):

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api_changes.md

# Cluster component Versions dependencies

if **Kube API Server** version X

**Controller Manager** can be v. X or X-1

**Kube ManagSchedulerer** can be v. X or X-1

**Kube ManagSchedulerer** can be v. X or X-1

**Kubelet** can be v. X, X-1 or X-2

**Kube Proxy** can be v. X, X-1 or X-2

**Kubectl** can be v. X+1, X or X-1

This allow live upgrades.

Upgrades should be done one minor version at a time
