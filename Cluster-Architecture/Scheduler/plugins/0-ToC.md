## **Table of Contents**  

1. **Introduction to Kubernetes Scheduling Plugins**  
   - Overview of Scheduling Plugins  
   - Benefits of Custom Scheduling Plugins  
   - Key Components of the Scheduling Framework  

2. **Understanding the Scheduling Phases**  
   - Queueing Phase  
   - Filtering Phase  
   - Scoring Phase  
   - Binding Phase  

3. **Queueing Phase Plugins**  
   - Purpose of the Queueing Phase  
   - Pre-Queue and Post-Queue Plugins  
   - Example Queueing Plugins  

4. **Filtering Phase Plugins**  
   - Role of Filtering in Scheduling  
   - How Filtering Plugins Work  
   - Common Filtering Plugins in Kubernetes  

5. **Scoring Phase Plugins**  
   - Purpose of Scoring in Scheduling  
   - Custom Scoring Plugins  
   - Weighted Scoring Strategies  

6. **Binding Phase Plugins**  
   - What Happens in the Binding Phase  
   - How Binding Plugins Assign Pods to Nodes  
   - Extending the Binding Process  

7. **Developing a Custom Scheduling Plugin**  
   - Writing a Custom Scheduling Plugin in Go  
   - Registering the Plugin with the Scheduler  
   - Deploying and Testing the Plugin in a Kubernetes Cluster  

8. **Best Practices for Scheduling Plugins**  
   - Optimizing Scheduling Performance  
   - Debugging and Monitoring Scheduling Decisions  
   - Ensuring Security and Stability  

[Official Documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)
