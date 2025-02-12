## 4. Helm Commands

### 4.1 Creating a New Chart
The `helm create` command scaffolds a new chart directory with a standard structure and default files, providing a starting point for your chart development.

Example:
```sh
helm create mychart
```
This creates a directory named `mychart` containing the necessary chart files and folders.

---

### 4.2 Installing a Chart
The `helm install` command deploys a Helm chart as a release on your Kubernetes cluster. It processes chart templates, applies default or overridden values, and creates the required Kubernetes resources.

Example:
```sh
helm install my-release mychart/
```
- **my-release:** The name assigned to the Helm release.
- **mychart/:** The path to the chart directory or a chart reference.

---

### 4.3 Upgrading a Release
The `helm upgrade` command updates an existing release with a new chart version or modified configuration values, enabling seamless application updates.

Example:
```sh
helm upgrade my-release mychart/
```
- **my-release:** The name of the existing release.
- **mychart/:** The updated chart directory or chart reference.

---

### 4.4 Rolling Back a Release
The `helm rollback` command reverts an existing release to a previous revision, which is useful in case of failed upgrades or misconfigurations.

Example:
```sh
helm rollback my-release 1
```
- **my-release:** The name of the release to roll back.
- **1:** The revision number to revert to.

---

### 4.5 Uninstalling a Release
The `helm uninstall` command removes a deployed release from your cluster by deleting all associated Kubernetes resources.

Example:
```sh
helm uninstall my-release
```
- **my-release:** The name of the release to uninstall.

---

### 4.6 Managing Repositories

#### 4.6.1 Adding Repositories
The `helm repo add` command adds a new chart repository to your Helm configuration, enabling you to search and fetch charts from that repository.

Example:
```sh
helm repo add stable https://charts.helm.sh/stable
```
- **stable:** The alias for the repository.
- **https://charts.helm.sh/stable:** The URL of the repository.

---

#### 4.6.2 Updating Repositories
The `helm repo update` command updates the local cache of chart repositories, ensuring you have access to the latest charts and versions.

Example:
```sh
helm repo update
```

---

#### 4.6.3 Searching for Charts
The `helm search repo` command searches the added repositories for charts that match a specific keyword or name.

Example:
```sh
helm search repo nginx
```
This command lists charts related to "nginx" available in your configured repositories.

Updating the document to include additional Helm commands:  

---

### 4.7 Fetching and Extracting Charts  

#### 4.7.1 Pulling a Chart  
The `helm pull` command downloads a chart from a repository and saves it as a `.tgz` archive locally. This is useful for inspecting or modifying a chart before installation.  

Example:  
```sh
helm pull stable/nginx
```  
- **stable/nginx:** The chart name and repository alias.  

---

#### 4.7.2 Pulling and Extracting a Chart  
The `helm pull --untar` command fetches a chart and extracts its contents into a local directory instead of saving it as a `.tgz` archive.  

Example:  
```sh
helm pull stable/nginx --untar
```  
This will create a `nginx/` directory containing the chart files.  

---

### 4.8 Listing Installed Releases  
The `helm list` command displays all installed releases in the cluster, showing details like release name, namespace, revision, status, and chart version.  

Example:  
```sh
helm list
```
- To list releases in a specific namespace:  
  ```sh
  helm list -n my-namespace
  ```  

---

### 4.9 Inspecting a Chart  
The `helm show` command allows users to inspect different aspects of a chart before installing it.  

#### 4.9.1 Viewing Chart Metadata  
To view general chart metadata, such as its version, description, and maintainers:  
```sh
helm show chart stable/nginx
```  

#### 4.9.2 Viewing Chart Values  
To see the default values provided by a chart, use:  
```sh
helm show values stable/nginx
```  

---

### 4.10 Packaging a Custom Chart  
The `helm package` command creates a `.tgz` archive from a local chart directory, making it ready for distribution or storage in a repository.  

Example:  
```sh
helm package mychart/
```  
This generates `mychart-1.0.0.tgz` (assuming version `1.0.0` is set in `Chart.yaml`).  

---

### 4.11 Verifying Chart Signatures  
If a Helm chart is signed, you can verify its integrity using the `helm verify` command.  

Example:  
```sh
helm verify mychart-1.0.0.tgz
```  
This ensures the chart was not tampered with and matches the provided signature.  
