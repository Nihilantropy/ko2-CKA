## **2. Installation**  

### **2.1 Prerequisites**  
Before installing Kustomize, ensure the following prerequisites are met:  

- **Kubernetes Cluster**: Kustomize is used for Kubernetes configurations, so a running cluster is recommended.  
- **kubectl Installed**: Since Kustomize is integrated into `kubectl`, ensure that `kubectl` is installed and configured.  
  - Verify installation with:  
    ```sh
    kubectl version --client
    ```
- **Internet Access**: Required for downloading Kustomize binaries and fetching remote bases.  

---

### **2.2 Installing Kustomize**  

Kustomize can be used in two ways:  
1. **As part of `kubectl`** (`kubectl kustomize`) – built-in but may not include the latest features.  
2. **As a standalone binary** – provides more control and access to newer features.  

#### **2.2.1 Installing via Kubernetes CLI (`kubectl kustomize`)**  
Kustomize is natively integrated into `kubectl`, allowing users to apply Kustomizations directly.  

To check if `kubectl` has Kustomize:  
```sh
kubectl kustomize --help
```  
To use Kustomize with `kubectl`:  
```sh
kubectl apply -k <kustomization_directory>
```  

✅ **Pros**: No extra installation required.  
❌ **Cons**: May not support the latest Kustomize features.  

---

#### **2.2.2 Installing Standalone Kustomize**  
For the latest version of Kustomize, install it as a standalone binary.  

##### **Method 1: Install via Script (Recommended)**  
Run the following command to download and install Kustomize:  
```sh
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
```
This installs `kustomize` in the current directory. Move it to `/usr/local/bin` for system-wide access:  
```sh
sudo mv kustomize /usr/local/bin/
```
Verify installation:  
```sh
kustomize version
```

##### **Method 2: Install via Package Manager**  
- **Homebrew (macOS/Linux)**:  
  ```sh
  brew install kustomize
  ```
- **Scoop (Windows)**:  
  ```sh
  scoop install kustomize
  ```

✅ **Pros**: Provides the latest features.  
❌ **Cons**: Requires manual installation and updates.  

---

#### **2.2.3 Verifying the Installation**  
After installation, confirm that Kustomize is working correctly:  

1. **Check version**:  
   ```sh
   kustomize version
   ```  
   Expected output (example):  
   ```
   {Version:kustomize/v5.1.0 GitCommit:xyz BuildDate:2024-01-01}
   ```

2. **Run a test command** to check if Kustomize processes a sample directory:  
   ```sh
   kustomize build <kustomization_directory>
   ```  
   This should output transformed Kubernetes manifests.  

If the installation is successful, Kustomize is ready to use! 🚀