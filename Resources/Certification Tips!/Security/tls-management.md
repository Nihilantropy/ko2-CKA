# **Kubernetes Certificate Management Guide**  

## **1️⃣ Viewing and Inspecting Certificates**  

### **Check Certificates Managed by Kubernetes**  
- List all certificate signing requests (CSRs):  
```sh
  kubectl get csr
```  
- Describe a specific CSR:  
```sh
  kubectl describe csr <csr-name>
```  
- List Kubernetes certificates stored in the PKI directory (for `kubeadm` clusters):  
```sh
  sudo ls -lah /etc/kubernetes/pki
```  
- Check certificate expiration dates:  
```sh
  sudo kubeadm certs check-expiration
```  
- Inspect details of a specific certificate:  
```sh
  openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
```  
- Verify the Kubernetes CA certificate:  
```sh
  openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout
```  
- Validate a certificate against the Kubernetes CA:  
```sh
  openssl verify -CAfile /etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/apiserver.crt
```  

---

## **2️⃣ Generating and Signing Certificates**  

### **Creating a New Certificate Signing Request (CSR)**  
- Generate a private key and CSR:  
```sh
  openssl req -new -newkey rsa:4096 -nodes -keyout my-key.key -out my-csr.csr -subj "/CN=my-service"
```  

### **Generating a Self-Signed Certificate**  
(Not recommended for production environments)  
```sh
  openssl req -x509 -new -nodes -key my-key.key -sha256 -days 365 -out my-cert.crt -subj "/CN=my-service"
```  

### **Signing a CSR with the Kubernetes CA**  
- Use Kubernetes’ CA to sign the request:  
```sh
  openssl x509 -req -in my-csr.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out my-cert.crt -days 365 -sha256
```  

---

## **3️⃣ Renewing Kubernetes Certificates**  

### **Renewing All Certificates in a Kubeadm-Managed Cluster**  
```sh
  sudo kubeadm certs renew all
```  

### **Renewing a Specific Certificate (e.g., API Server Certificate)**  
```sh
  sudo kubeadm certs renew apiserver
```  

### **Restarting Services After Certificate Renewal**  
After renewing certificates, restart `kubelet` to apply the changes:  
```sh
  sudo systemctl restart kubelet
```  

### **Forcing Kubelet Certificate Rotation**  
- Delete existing CSRs and force nodes to generate new requests:  
```sh
  kubectl delete csr --all
```  
- Restart the API server to trigger reauthentication:  
```sh
  kubectl delete pod -n kube-system -l component=kube-apiserver
```  

---

## **4️⃣ Managing Certificate Signing Requests (CSRs)**  

### **Approving or Denying CSRs**  
- Approve a pending CSR:  
```sh
  kubectl certificate approve <csr-name>
```  
- Deny a CSR:  
```sh
  kubectl certificate deny <csr-name>
```  
- Delete a CSR:  
```sh
  kubectl delete csr <csr-name>
```  

### **Creating a New Kubelet Certificate Request**  
```sh
kubeadm alpha certs renew kubelet
```  

---

## **5️⃣ Troubleshooting Certificate Issues**  

### **Checking Logs for Certificate Errors**  
- Inspect `kubelet` logs:  
```sh
  sudo journalctl -u kubelet -f --no-pager
```  
- Verify if a certificate is expired:  
```sh
  openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver.crt
```  
- Ensure `kube-apiserver` can authenticate with `kubelet`:  
```sh
  kubectl get nodes
```  
- Restart control plane components after manual certificate updates:  
```sh
  sudo systemctl restart kubelet
```  

---

## **6️⃣ Backup and Restore Kubernetes Certificates**  

### **Backing Up Kubernetes Certificates**  
- Backup all Kubernetes PKI files:  
```sh
  sudo tar -cvzf kubernetes-pki-backup.tar.gz /etc/kubernetes/pki
```  
- Verify the backup:  
```sh
  tar -tvf kubernetes-pki-backup.tar.gz
```  
- Store backups securely (e.g., off-cluster storage or cloud storage).  

### **Restoring Certificates from a Backup**  
- Extract the backup:  
```sh
  sudo tar -xvzf kubernetes-pki-backup.tar.gz -C /
```  
- Restart services to apply restored certificates:  
```sh
  sudo systemctl restart kubelet
```  

---

## **7️⃣ Best Practices for Managing Kubernetes Certificates**  

- **Monitor Expiry Dates**: Regularly check expiration using `kubeadm certs check-expiration`.  
- **Use Automated Renewal**: Ensure kubelet rotates certificates automatically.  
- **Restrict Certificate Access**: Store and manage certs securely with proper file permissions.  
- **Use External Certificate Management**: Consider integrating with cert managers like **cert-manager** for automated TLS management.  
- **Regularly Backup PKI Data**: Always maintain up-to-date backups for disaster recovery.  
