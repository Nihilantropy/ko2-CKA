# **Kubernetes Secrets Documentation**

## **Overview**

Kubernetes Secrets provide a way to store and manage sensitive data, such as passwords, OAuth tokens, SSH keys, and more. They are designed to keep sensitive information separate from your application code, thereby ensuring that credentials, passwords, and certificates can be securely managed and accessed by Kubernetes resources such as Pods, Deployments, and StatefulSets.

Secrets in Kubernetes are stored in the Kubernetes API server and can be accessed only by authorized resources based on Kubernetes' Role-Based Access Control (RBAC) policies.

## **Why Use Secrets?**

Sensitive information such as passwords, API keys, and certificates should never be hardcoded into application code or container images. Kubernetes Secrets provide a secure and centralized way to manage this data, offering benefits such as:

- **Separation of sensitive data from application code**.
- **Encryption at rest**: Secrets are encrypted when stored in the Kubernetes cluster.
- **Access control**: Fine-grained access control to secrets via RBAC.
- **Environment-specific secrets**: Easy to manage environment-specific configurations without hardcoding them.
- **Dynamic secrets management**: Secrets can be rotated or updated without needing to restart applications or modify container images.

## **Types of Kubernetes Secrets**

1. **Opaque**: The default type of Secret used to store arbitrary data in key-value pairs. This is the most commonly used Secret type.
2. **dockerconfigjson**: A type used for storing Docker credentials to authenticate with a Docker registry.
3. **service-account-token**: Automatically created by Kubernetes for each service account, containing a token used for API authentication.
4. **Basic authentication (kubernetes.io/basic-auth)**: Used for storing usernames and passwords for HTTP basic authentication.
5. **SSH authentication (kubernetes.io/ssh-auth)**: Stores SSH keys to be used by containers or applications requiring SSH authentication.
6. **TLS certificates (kubernetes.io/tls)**: Stores a TLS certificate and a corresponding private key to be used by applications requiring TLS/SSL connections.

## **Creating Secrets**

Secrets can be created from literal values, files, environment variables, or even by referencing external secret managers.

### **1. Creating Secrets from Literal Values**

You can create a Secret from literal key-value pairs, which is useful for simple secrets like passwords or API keys.

```bash
kubectl create secret generic db-password --from-literal=password=mysecretpassword
```

This creates a Secret named `db-password` with a single key-value pair.

### **2. Creating Secrets from Files**

Secrets can be created by reading the contents of a file. For example, to store an SSH private key in a Secret:

```bash
kubectl create secret generic ssh-key --from-file=ssh-private-key=./ssh-key.txt
```

This creates a Secret where the key `ssh-private-key` holds the contents of the `ssh-key.txt` file.

### **3. Creating Secrets from Multiple Files**

You can create a Secret from multiple files at once by providing multiple `--from-file` arguments.

```bash
kubectl create secret generic my-secrets --from-file=config1.yaml --from-file=config2.yaml
```

Each file will be represented as a key in the Secret with the file's name as the key and its content as the value.

### **4. Creating Secrets from Environment Variables**

Secrets can be created from environment variables stored in a `.env` file.

```bash
kubectl create secret generic app-secrets --from-env-file=secrets.env
```

Where `secrets.env` contains:
```
API_KEY=abc123
DB_PASSWORD=supersecret
```

### **5. Creating Secrets from a JSON or YAML Configuration File**

If you already have a configuration file, you can apply it directly to create a Secret.

```bash
kubectl apply -f secret.yaml
```

Example `secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: dXNlcm5hbWU=   # Base64 encoded 'username'
  password: cGFzc3dvcmQ=   # Base64 encoded 'password'
```

In this example, the `data` section stores the encoded version of the secret values.

## **Viewing Secrets**

You can view the metadata of Secrets (such as their names and types) using:

```bash
kubectl get secrets
```

To describe a specific Secret and view its details:

```bash
kubectl describe secret <secret-name>
```

Note that the Secret data will be encoded in **base64**. You must decode it manually to view the actual content. You can use the `base64` command to decode it:

```bash
echo <base64-encoded-value> | base64 --decode
```

Alternatively, to decode a Secret value directly from the command line:

```bash
kubectl get secret <secret-name> -o jsonpath='{.data.<key>}' | base64 --decode
```

## **Accessing Secrets in Pods**

Secrets can be accessed in Pods in two primary ways:
1. **As environment variables**
2. **As files mounted in volumes**

### **1. Accessing Secrets as Environment Variables**

You can use Secrets as environment variables within Pods. This allows your application to access the sensitive data without hardcoding it in the code.

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-example
spec:
  containers:
  - name: my-container
    image: my-image
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-password
          key: password
```

In this example, the value of the `password` key from the `db-password` Secret will be passed as the `DB_PASSWORD` environment variable inside the container.

### **2. Accessing Secrets as Files Mounted in Volumes**

Secrets can be mounted as files within a container. Each key in the Secret becomes a filename, and the corresponding value is stored in the file.

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-example
spec:
  containers:
  - name: my-container
    image: my-image
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
  volumes:
  - name: secret-volume
    secret:
      secretName: db-password
```

In this example, the `db-password` Secret will be mounted at `/etc/secrets`, and each key-value pair in the Secret will be available as a file within that directory.

## **Best Practices for Managing Secrets**

### **1. Enable Encryption at Rest**

By default, Kubernetes Secrets are stored in **plaintext** in etcd. To secure them, you should enable **encryption at rest** in the Kubernetes API server. This ensures that Secrets are encrypted when stored in the cluster’s etcd datastore.

To enable encryption, you need to modify the API server configuration file (`kube-apiserver.yaml`) and specify the encryption provider configuration.

Example `encryption-config.yaml`:
```yaml
apiVersion: encryption.k8s.io/v1
kind: EncryptionConfig
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: <base64-encoded-key>
      - identity: {}
```

Then, specify the `--encryption-provider-config` flag when starting the API server.

### **2. Restrict Access to Secrets**

Use **RBAC (Role-Based Access Control)** to ensure only authorized users and services can access the Secrets. This is crucial for limiting exposure to sensitive data.

Example RBAC policy:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: secret-accessor
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list"]
```

### **3. Use External Secret Management Systems**

For enhanced security and centralized management, consider integrating Kubernetes with an external secrets management system, such as **HashiCorp Vault**, **AWS Secrets Manager**, or **Azure Key Vault**. These tools provide additional features, like automatic rotation of secrets, more granular access controls, and logging.

### **4. Use Secrets in Deployment Configurations**

Use Secrets in **Deployment** or **StatefulSet** configurations, where you can manage environment variables or volumes at scale.

### **5. Rotate Secrets Regularly**

Rotating Secrets is essential for maintaining security. Consider automating secret rotation by integrating with external secret management tools. This ensures that the secrets are updated periodically and automatically propagated to applications.

### **6. Avoid Storing Sensitive Data in Git Repositories**

Never store Kubernetes Secrets in version-controlled repositories, especially public ones. Use tools like **Helm Secrets** to securely manage the storage and encryption of Secrets in a version-controlled environment.

## **Security Considerations**

- **RBAC**: Implement RBAC policies to control who can access Secrets.
- **Audit Logging**: Enable Kubernetes auditing to track access to Secrets and detect any unauthorized attempts to access sensitive data.
- **Network Policies**: Use **Network Policies** to restrict which services or Pods can access certain Secrets. This can help in preventing unauthorized access to sensitive data over the network.

## **Deleting Secrets**

To delete a Secret:

```bash
kubectl delete secret <secret-name>
```

This removes the Secret from the Kubernetes cluster, ensuring that the sensitive data is no longer accessible.
