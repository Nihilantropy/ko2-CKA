## Static Pods Tips!

To remove a static pod present in a node different on the current one, we need to ssh inside the node of the pod is running on, search for the `staticPodPath:` present in the `var/lib/kubelet/config.yaml` file and there we will find the manifest of the static pod.