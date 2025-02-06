# Scheduler Profile Documentation

## Introduction

In Kubernetes, **Scheduler Profiles** are a mechanism that allows you to define and customize the behavior of the Kubernetes scheduler for different workloads. Each profile consists of a set of configurations, including plugin definitions, custom scheduling logic, and other parameters that influence how the scheduler assigns pods to nodes.

This document will explain what Scheduler Profiles are, how to configure them, and their use cases.

## What is a Scheduler Profile?

A **Scheduler Profile** in Kubernetes is a collection of settings and configurations that define how the Kubernetes scheduler behaves when scheduling pods. This enables you to run multiple schedulers with different configurations in a single cluster, making it possible to customize scheduling behaviors based on the type of workload being scheduled.

By default, Kubernetes uses a single scheduler, known as the **default scheduler**, to schedule all pods in the cluster. However, with Scheduler Profiles, you can configure different scheduling logic for different workloads (such as production applications, batch jobs, or high-priority services).

Each profile allows you to configure:
- **Plugins:** Various scheduling phases (such as filtering, scoring, and binding) that can be customized.
- **Plugin Configurations:** Fine-tuning of the plugins’ behavior.
- **Scheduling Logic:** Tailoring of specific scheduling rules, such as affinity/anti-affinity or resource requests.

## Components of a Scheduler Profile

A Scheduler Profile typically contains the following key components:

### 1. **Scheduler Name**
Each profile is associated with a `schedulerName` to differentiate it from other profiles. The `schedulerName` can be the default scheduler (`default-scheduler`) or a custom name for a specialized scheduler (e.g., `batch-scheduler`).

### 2. **Plugins**
A profile specifies which plugins to use in each phase of the scheduling process. Kubernetes uses a plugin-based architecture for scheduling, which includes phases like **queue sorting**, **filtering**, **scoring**, and **binding**. You can configure specific plugins for each phase of scheduling in the profile.

Common plugins include:
- **Queue Sort:** Defines how the scheduling queue is ordered.
- **Filter:** Filters nodes based on the pod's requirements (e.g., node affinity).
- **Score:** Scores nodes based on resource availability or other custom criteria.
- **Bind:** Decides how the pod is bound to the node.

### 3. **Plugin Configurations**
Each plugin can be customized by providing arguments within the `pluginConfig` section. These configurations adjust the behavior of each plugin based on the specific needs of your workload.

### 4. **Other Scheduling Parameters**
In addition to plugins, the profile can include other scheduling parameters, such as resource constraints, affinity/anti-affinity rules, taints and tolerations, and custom preemption policies.

## Example Scheduler Profile Configuration

Here’s an example of a Kubernetes scheduler configuration with two profiles:

```yaml
apiVersion: scheduler.config.k8s.io/v1beta2
kind: KubeSchedulerConfiguration
profiles:
  - schedulerName: default-scheduler
    plugins:
      bind:
        - name: DefaultBinder
      queueSort:
        - name: PrioritySort
    pluginConfig:
      - name: PrioritySort
        args:
          weight: 10

  - schedulerName: batch-scheduler
    plugins:
      bind:
        - name: DefaultBinder
      queueSort:
        - name: FIFO
    pluginConfig:
      - name: FIFO
        args: {}
```

In this configuration:

- **`schedulerName`**: Defines two different schedulers—`default-scheduler` and `batch-scheduler`.
- **Plugins**: 
  - The `default-scheduler` uses the `PrioritySort` queue sorting plugin, which orders pods by their priority.
  - The `batch-scheduler` uses the `FIFO` (First In, First Out) queue sorting plugin to schedule pods in the order they are received.
- **Plugin Configurations**: Each plugin has a set of arguments to fine-tune its behavior. In the `PrioritySort` plugin, a `weight` argument is defined, affecting how priorities are handled during the scheduling process.

## Configuring Scheduler Profiles

### 1. **Multiple Profiles in a Cluster**
To implement multiple scheduler profiles, define them within the `KubeSchedulerConfiguration` file, specifying the `schedulerName` for each profile. This ensures that different workloads can be scheduled based on their specific requirements. The configuration is then applied to the scheduler component.

### 2. **Assigning Pods to Specific Profiles**
When creating a pod, you specify which scheduler profile to use by setting the `schedulerName` field in the pod’s specification. For example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-critical-app
spec:
  schedulerName: batch-scheduler
  containers:
    - name: app-container
      image: my-critical-app:latest
```

In this example, the pod `my-critical-app` will be scheduled using the `batch-scheduler` profile instead of the default one. This is useful when you want to apply different scheduling logic or resource policies to specific types of workloads.

### 3. **Running Multiple Schedulers**
To enable multiple schedulers, you must run separate instances of the Kubernetes scheduler, each configured with a different profile. Each scheduler instance should be associated with its own configuration file.

For example:
- One scheduler may be configured to prioritize high-availability applications, while another scheduler is dedicated to batch processing jobs that can tolerate delays.

To configure multiple schedulers, update the scheduler deployment or pod configuration to specify the correct scheduler profile.

## Use Cases for Scheduler Profiles

### 1. **Workload-Specific Scheduling**
Scheduler Profiles are particularly useful in environments where different types of workloads require different scheduling behaviors. For instance:
- **Production Applications:** High-priority workloads like production applications can be assigned a profile with custom plugins to ensure they are always scheduled promptly and avoid preemption.
- **Batch Jobs:** Batch jobs with less urgency can be scheduled with a profile that uses less aggressive queue sorting (e.g., FIFO) or is less sensitive to preemption.

### 2. **Multi-Tenancy**
In multi-tenant clusters, different teams or departments may have different needs regarding resource allocation and scheduling. By defining separate profiles, you can tailor the scheduler behavior for each tenant's specific needs without interfering with other workloads.

### 3. **High-Availability and Fault-Tolerant Scheduling**
Critical workloads, such as those requiring high availability or specific fault-tolerance guarantees, can benefit from a profile that ensures they are scheduled on the most appropriate nodes based on node affinity, resource availability, and other critical factors.

### 4. **Custom Scheduling Logic**
You can use Scheduler Profiles to implement customized scheduling strategies tailored to your specific use cases. For instance, you might want to schedule workloads in a way that accounts for a custom resource metric, external factors, or a specialized affinity rule that differs from the default scheduler behavior.

## Troubleshooting Scheduler Profiles

### 1. **Incorrect Scheduler Profile Assignment**
Ensure that the pod is being assigned the correct scheduler profile. If you notice that pods are not being scheduled as expected, verify the `schedulerName` field in the pod specification.

### 2. **Plugin Conflicts or Errors**
If your scheduler configuration includes multiple plugins or custom configurations, verify that they do not conflict with one another. Check the logs for errors related to plugin configurations and adjust as necessary.

### 3. **Resource Overload in Specific Profiles**
If a certain scheduler profile causes resource overload or delays, consider revisiting the plugin configurations and adjusting scheduling parameters like priorities, node resource requests, or affinity rules.

## Conclusion

Scheduler Profiles provide Kubernetes users with the flexibility to define and manage multiple scheduling behaviors in a single cluster. By leveraging Scheduler Profiles, you can ensure that different workloads receive the appropriate scheduling logic, resource allocation, and prioritization to meet the unique needs of your applications.

Scheduler Profiles offer powerful customization options for complex clusters, including multi-tenancy environments, diverse workloads, and high-availability configurations. By defining and utilizing Scheduler Profiles effectively, you can ensure more efficient, predictable, and scalable scheduling decisions within your Kubernetes cluster.

