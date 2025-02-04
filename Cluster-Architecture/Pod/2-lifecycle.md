# 2️⃣ Pod Lifecycle

The lifecycle of a Pod in Kubernetes defines the various states and behaviors that a Pod goes through from creation to termination. Understanding the Pod lifecycle is crucial for managing Pods effectively and handling errors, restarts, and graceful shutdowns.

## Phases: Pending, Running, Succeeded, Failed, Unknown

A Pod goes through several phases during its lifecycle, which describe its overall state at any given time. These phases help you understand what the Pod is doing and whether it is functioning as expected.

### 1. **Pending**
- **Description**: The Pod has been created, but one or more of its containers are not yet running. This phase includes the time spent waiting for the container image to be pulled, resources to be allocated, or for the node to become available for scheduling.
- **Common causes for Pending state**:
  - Insufficient resources (CPU, memory) available in the cluster.
  - Unmet resource requests or quotas.
  - Scheduling issues due to node affinity or taints.

### 2. **Running**
- **Description**: The Pod's containers are running, and the Pod is active. The Pod is in the Running state when at least one container is actively running and all the containers in the Pod are in the Running or Completed state.
- **Common causes for Running state**:
  - The Pod has been successfully scheduled and is running on a node with the required resources.

### 3. **Succeeded**
- **Description**: The Pod has completed its execution successfully. All containers in the Pod have terminated with a zero exit status (indicating successful completion).
- **Common causes for Succeeded state**:
  - Pods that run batch jobs or are short-lived containers that terminate successfully after performing their tasks.

### 4. **Failed**
- **Description**: The Pod's containers have terminated, but with a non-zero exit status. This indicates that there was an error during execution. The Pod has failed to perform its intended task.
- **Common causes for Failed state**:
  - Errors in container startup, such as missing dependencies or incorrect configurations.
  - Runtime errors in the application or script running within the container.

### 5. **Unknown**
- **Description**: The Pod's state is unknown. This phase typically occurs when Kubernetes cannot determine the state of the Pod due to an issue with communication between the API server and the node hosting the Pod.
- **Common causes for Unknown state**:
  - Network issues or failures in the communication between the kubelet and the API server.
  - Node failures or unreachable nodes.

## Pod Restart Policies

Kubernetes defines a restart policy for Pods to manage container restarts in case of failure. The restart policy determines whether and how containers should be restarted when they exit.

### 1. **Always** (Default)
- **Description**: Containers are always restarted regardless of their exit status. This is the default restart policy for Pods.
- **Use case**: Ideal for long-running applications or services that should always be running.

### 2. **OnFailure**
- **Description**: Containers are restarted only if they exit with a non-zero exit code. This is suitable for batch jobs or containers that may fail intermittently but should be retried.
- **Use case**: Useful for jobs where a failure needs to be handled and the container needs to be retried.

### 3. **Never**
- **Description**: Containers are not restarted, regardless of their exit status. Once the container exits (successfully or with failure), it will not be restarted.
- **Use case**: Useful for short-lived tasks or jobs where no retry is needed after completion.

## Pod Termination & Graceful Shutdown

When a Pod is terminated, Kubernetes ensures that the termination process is handled in a controlled and graceful manner. This helps avoid data corruption and ensures that the application inside the container has time to clean up before shutting down.

### 1. **Termination Grace Period**
- **Description**: The termination grace period is the time Kubernetes allows for a container to gracefully shut down after receiving a termination signal (SIGTERM). The default grace period is 30 seconds.
- **Customizing Grace Period**: You can adjust the grace period in the Pod specification using the `terminationGracePeriodSeconds` field. This allows you to provide more time for cleanup if your application needs it.
```yaml  
  terminationGracePeriodSeconds: 60
```
### 2. **PreStop Hook**
- **Description**: Kubernetes allows you to define a `preStop` lifecycle hook that is executed before a container is terminated. This hook can be used to perform any cleanup tasks or graceful shutdown steps.
```yaml  
  lifecycle:
    preStop:
      exec:
        command: ["sh", "-c", "echo 'Cleaning up before shutdown'"]
```
### 3. **Graceful Shutdown Process**
- **Steps**:
  1. Kubernetes sends a `SIGTERM` signal to the container to initiate shutdown.
  2. The container is given the termination grace period to handle any cleanup.
  3. If the container doesn't terminate within the grace period, Kubernetes sends a `SIGKILL` signal to forcibly terminate the container.
  
## Summary

The Pod lifecycle describes the sequence of states that a Pod goes through, including Pending, Running, Succeeded, Failed, and Unknown. Understanding the lifecycle of Pods helps to manage their behavior, handle failures, and ensure proper termination and graceful shutdowns.

- **Pod Phases**: Pending, Running, Succeeded, Failed, and Unknown define the overall state of the Pod.
- **Restart Policies**: Defines how Pods handle restarts for containers based on their exit status.
- **Pod Termination & Graceful Shutdown**: Ensures containers are given enough time to shut down cleanly, using grace periods and lifecycle hooks to handle cleanup operations.

---

## **References**

1. **Pod Lifecycle Phases**
   - [Pod Lifecycle - Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
   - [Pod Phases and Conditions - Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/#pod-phases)

2. **Pod Restart Policies**
   - [Pod Restart Policies - Kubernetes](https://kubernetes.io/docs/concepts/workloads/pods/#restart-policy)

3. **Pod Termination & Graceful Shutdown**
   - [Graceful Termination - Kubernetes](https://kubernetes.io/docs/docs/concepts/workloads/pods/#graceful-termination)
   - [PreStop Hook - Kubernetes](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#prestopping)
