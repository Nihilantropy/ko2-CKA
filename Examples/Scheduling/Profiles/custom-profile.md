Here's an example of a Kubernetes **scheduler profile** configuration that includes different scheduling profiles, with custom plugins applied to certain phases and some default plugins disabled in others.

### Example: Scheduler Profile with Custom Plugins and Disabled Default Plugins

```yaml
apiVersion: scheduler.config.k8s.io/v1beta2
kind: KubeSchedulerConfiguration
profiles:
  # Default scheduler profile
  - schedulerName: default-scheduler
    plugins:
      queueSort:
        - name: PrioritySort  # Use custom queue sorting based on priority
      filter:
        - name: NodeAffinity  # Use the default NodeAffinity filter plugin
        - name: TaintToleration # Default taint-toleration filter
      score:
        - name: ImageLocality  # Default plugin for image locality scoring
      bind:
        - name: DefaultBinder  # Use default binder to bind pods to nodes
    pluginConfig:
      # Custom plugin configurations for PrioritySort (used in queue sorting phase)
      - name: PrioritySort
        args:
          weight: 15
          
  # Batch scheduler profile (custom scheduling for batch jobs)
  - schedulerName: batch-scheduler
    plugins:
      queueSort:
        - name: FIFO  # Use FIFO (First In, First Out) for batch job scheduling
      filter:
        - name: NodeResourcesFit  # Use custom resource fit filter
        - name: Affinity  # Use affinity filter
      score:
        - name: NodeResourcesAllocated  # Custom scoring for node resource allocation
      bind:
        - name: DefaultBinder  # Default binder for binding pods
    pluginConfig:
      # Disable scoring in this profile by not specifying any scoring plugins
      # Custom plugin configuration for NodeResourcesAllocated
      - name: NodeResourcesAllocated
        args:
          weight: 20

  # High-priority scheduler profile (custom scheduling for high-priority applications)
  - schedulerName: high-priority-scheduler
    plugins:
      queueSort:
        - name: PrioritySort  # Custom priority sorting
      filter:
        - name: NodeResourcesFit  # Ensure nodes have sufficient resources
        - name: TaintToleration  # Ensure tolerations are respected for tainted nodes
      score:
        - name: ImageLocality  # Keep pods on nodes where their images are stored locally
      bind:
        - name: DefaultBinder  # Use default binder
    pluginConfig:
      # Disable the default `DefaultPreemption` plugin for high-priority jobs
      - name: DefaultPreemption
        disabled: true  # Disable preemption plugin for this profile

  # Custom scheduler profile with no plugins
  - schedulerName: no-plugins-scheduler
    plugins: {}  # No plugins used, this scheduler will rely on default behavior
    pluginConfig: []  # No custom plugin configurations
```

### Explanation of Profiles and Configurations:

1. **`default-scheduler`:**
   - This is the default scheduler profile with typical plugins enabled for basic filtering, scoring, and binding.
   - **Queue Sort:** Uses `PrioritySort` to prioritize pods based on their priority.
   - **Filter:** Uses `NodeAffinity` and `TaintToleration` filters, which are standard plugins to consider node affinity rules and tolerations.
   - **Score:** Uses `ImageLocality`, which prefers nodes where images are already cached.
   - **Bind:** Uses the default `DefaultBinder` plugin for pod-to-node binding.

2. **`batch-scheduler`:**
   - This profile is tailored for batch jobs.
   - **Queue Sort:** Uses `FIFO` (First In, First Out) for scheduling batch jobs in the order they arrive.
   - **Filter:** The `NodeResourcesFit` filter is applied to ensure nodes have sufficient resources for the pod, while the `Affinity` filter ensures affinity rules are respected.
   - **Score:** Uses a custom scoring plugin, `NodeResourcesAllocated`, which scores nodes based on their resource allocation.
   - **Bind:** Uses `DefaultBinder` to assign pods to nodes.

3. **`high-priority-scheduler`:**
   - This profile is for high-priority applications that should be scheduled with minimal preemption.
   - **Queue Sort:** Uses `PrioritySort` to prioritize high-priority applications over others.
   - **Filter:** The `NodeResourcesFit` and `TaintToleration` filters are used to ensure only suitable nodes are considered.
   - **Score:** Uses `ImageLocality` to prefer nodes where the application image is available locally, reducing the time for container start.
   - **Bind:** Uses `DefaultBinder` for pod binding.
   - **Custom Configuration:** Disables the default `DefaultPreemption` plugin to prevent preempting existing lower-priority pods for high-priority applications.

4. **`no-plugins-scheduler`:**
   - This profile has no custom plugins and relies on the default scheduling behavior. It’s effectively a minimal configuration where no additional scheduling logic is applied.

### How to Use These Profiles

- **Assigning a Profile to a Pod:**
  You can specify which scheduler to use for a pod by setting the `schedulerName` field in the pod's YAML manifest. For example, to use the `batch-scheduler`, specify it like this:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: batch-job-pod
  spec:
    schedulerName: batch-scheduler
    containers:
      - name: batch-job-container
        image: my-batch-job-image:latest
  ```

- **Running Multiple Schedulers:**
  To run these multiple schedulers in the same cluster, you must deploy multiple instances of the Kubernetes scheduler, each configured to use a different profile. For example, you would deploy the `batch-scheduler` and `high-priority-scheduler` as separate scheduler instances with their respective configurations.

## Summary

This example demonstrates how to define different **Scheduler Profiles** in Kubernetes with custom plugins and plugin configurations. By customizing the scheduling behavior with specific plugins, disabling default plugins, and assigning profiles to different workloads, Kubernetes users can tailor the scheduling process to meet the unique needs of various workloads—whether they are high-priority applications, batch jobs, or other specialized use cases.