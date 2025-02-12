## 2. Installation

### 2.1 Prerequisites
Before installing Helm, ensure you have the following prerequisites in place:

- **Kubernetes Cluster:** A running Kubernetes cluster (e.g., Minikube, Kubeadm, or a managed cloud service).
- **kubectl:** The Kubernetes command-line tool should be installed and configured to interact with your cluster.
- **Operating System Compatibility:** A system that supports the installation methods outlined here (macOS, Debian/Ubuntu, etc.).

---

### 2.2 Installing Helm
Helm can be installed using multiple methods. Choose the method that best suits your environment.

#### 2.2.1 Installation via Script
Helm provides an installation script that automatically downloads and installs the latest version. Run the following command in your terminal:

```sh
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

This command performs the following actions:
- Downloads the official Helm installation script.
- Executes the script to install the latest Helm release on your system.

---

#### 2.2.2 Installation via Package Manager

##### Homebrew (macOS)
For macOS users, Homebrew offers a straightforward installation process:

1. **Update Homebrew:**

   ```sh
   brew update
   ```

2. **Install Helm:**

   ```sh
   brew install helm
   ```

##### APT (Debian/Ubuntu)
For Debian or Ubuntu systems, Helm can be installed via APT:

1. **Update your package list:**

   ```sh
   sudo apt-get update
   ```

2. **Add Helm’s signing key:**

   ```sh
   curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
   ```

3. **Add the Helm APT repository:**

   ```sh
   sudo apt-get install apt-transport-https --yes
   echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
   ```

4. **Update APT repositories and install Helm:**

   ```sh
   sudo apt-get update
   sudo apt-get install helm
   ```

---

#### 2.2.3 Post-Installation Verification
After installation, verify that Helm is correctly installed and accessible:

1. **Check the Helm version:**

   ```sh
   helm version
   ```

   You should see output indicating the installed Helm version.

2. **Verify the Helm executable path:**

   ```sh
   which helm
   ```

   The command should display the path where Helm is installed.

3. **Test Helm functionality by listing repositories:**

   ```sh
   helm repo list
   ```

   This command confirms that Helm is functioning as expected.
