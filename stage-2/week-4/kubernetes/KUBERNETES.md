```
Kubernetes Tasks

1. Buatlah sebuah kubernetes cluster, yang di dalamnya terdapat 3 buah node as a master and worker.
2. Install ingress nginx using helm or manifest
3. Deploy aplikasi yang kalian gunakan di docker swarm, ke dalam kubernetes cluster yang terlah kalian buat di point nomer 1.
4. Setup persistent volume untuk database kalian
5. Deploy database mysql with statefullset and use secrets
6. Install cert-manager ke kubernetes cluster kalian, lalu buat lah wildcard ssl certificate.

Ingress
fe : name.kubernetes.studentdumbways.my.id
be : api.name.kubernetes.studentdumbways.my.id
```

# Arstitektur Kubernetes

![image](https://github.com/user-attachments/assets/92d795aa-f260-41be-9d17-84a6b43c38c3)

## Buat kubernetes cluster

Untuk membuat cluster K3s kita wajib lihat dokumentasi resmi dari k3s untuk instalasi master node terlebih dahulu, setelah master node dibuat tinggal kita lakukan join saja untuk para worker node nya dengan menggunakan ip address dari master dan juga token khusus dari master node.

```
# command install K3S master
curl -sfL https://get.k3s.io | sh -

# Get token
sudo cat /var/lib/rancher/k3s/server/node-token

# command Join K3S worker node to master node
curl -sfL https://get.k3s.io | K3S_URL=https://<ip_addr>:6443 K3S_TOKEN=mynodetoken sh -
```
Sekarang kita sudah mempunyai sebuah kubernetes cluster dengan 3 node ( 1 master 2 worker )

![image](https://github.com/user-attachments/assets/8ca2459f-53b4-4c19-9a0a-3889d8c58f21)

## Install Nginx-Ingress Dengan Helm

```
# Tambahkan Repository Helm
helm repo add ingress-nginx https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/helm-chart/ingress-nginx

helm repo update

# Instal NGINX Ingress Controller
helm install nginx-ingress ingress-nginx/ingress-nginx

# Verifikasi Instalasi
kubectl get pods --namespace ingress-nginx 

```

![image](https://github.com/user-attachments/assets/dc943729-cf81-410f-a828-4d15bf2902c9)

## Deploy Database

- Buat Storage Class untuk mengelola penyimpanan persisten volume 

![image](https://github.com/user-attachments/assets/54f44db4-5537-45ac-8f1b-e918ab4921b4)

- Buat Secret untuk menampung environment yang dibutuhkan

![image](https://github.com/user-attachments/assets/77ff6d76-0d87-4469-a1a2-b275e9815088)

- Buat konfigurasi dengan resources statefulset dan service
  - Jangan lupa untuk membuat pvc dan masukan storage class yang sudah kita buat tadi

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: literature
spec:
  serviceName: "mysql"
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
              name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret-2
                  key: mysql-root-password
            - name: MYSQL_USER
              valueFrom:
                secretKeyRef:
                  name: mysql-secret-2
                  key: mysql-user
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret-2
                  key: mysql-password
            - name: MYSQL_DATABASE
              valueFrom:
                secretKeyRef:
                  name: mysql-secret-2
                  key: mysql-database
          volumeMounts:
            - name: mysql-data
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: mysql-data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 2Gi
        storageClassName: mysql-local

---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: literature
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
  type: ClusterIP

```

- Verifikasi apakah database sudah terdeploy dengan environment yang kita masukan tadi

![image](https://github.com/user-attachments/assets/d6d6bfb5-cb2d-4684-9733-1debc3c0ad12)

![image](https://github.com/user-attachments/assets/4279efef-aa04-4982-9c86-1f6130dc4864)

Masuk ke pod mysql yang sudah terbuat dan check username dan database 

```
kubectl exec -it mysql-0 -n literature -- /bin/sh
```

![image](https://github.com/user-attachments/assets/e77b142f-f9cc-41a7-9b6a-1d8f4867e7a1)

## Deploy Backend

- Buat konfigurasi backend dengan image yang sudah dikonfigurasi dan di push ke docker registry

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: backend
    namespace: literature
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: backend
    template:
      metadata:
        labels:
          app: backend
      spec:
        containers:
          - name: backend
            image: reyhanalvr/literature-be:swarm
            ports:
              - containerPort: 5000
        nodeSelector:
          deploy: literature
  
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: backend
    namespace: literature
  spec:
    selector:
      app: backend
    ports:
      - protocol: TCP
        port: 5000
        targetPort: 5000
    type: ClusterIP
  ```

- Verifikasi apakah backend sudah terdeploy

Disini sudah terlihat bahwa deployment dan service dari backend sudah terbuat

![image](https://github.com/user-attachments/assets/cc3312e4-dc47-4fba-96d9-8eb90946c036)

![image](https://github.com/user-attachments/assets/e852dc94-8ced-41b5-888e-a32d3ee9726a)

![image](https://github.com/user-attachments/assets/d1ecff54-ffda-4e8c-b0ef-60edbe122e35)


Jangan lupa untuk lakukan db migrate dan check apakah database sudah terhubung dengan backend atau belum

![image](https://github.com/user-attachments/assets/42742c7e-8a27-4b18-881b-e893f866739b)


## Deploy Frontend

- Buat konfigurasi frontend dengan image yang sudah dikonfigurasi dan di push ke docker registry
  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: literature
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: reyhanalvr/literature-fe:kubernetesV2
          ports:
            - containerPort: 80
      nodeSelector:
        deploy: literature

---
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: literature
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      # nodePort: 30080
  type: ClusterIP
```

- Verifikasi frontend sudah terdeploy
  
![image](https://github.com/user-attachments/assets/1973da7d-038a-477b-a463-23167ac00a6b)

## Buat wildcard certificate ssl dengan bantuan cert-manager

### Install Cert-manager Dengan Helm

```
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true
```

- Buat secret untuk menampung dns cloudflare api token kita

```
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: literature
type: Opaque
stringData:
  api-token: 
```

![image](https://github.com/user-attachments/assets/ed52a06f-3dc2-4218-acb6-15fdfd4d738d)

- Buat Issuer
  - Issuer pada Cert-Manager adalah entitas yang bertanggung jawab untuk menentukan bagaimana sertifikat diterbitkan. Itu bisa dikonfigurasi untuk bekerja dengan berbagai Certificate Authority (CA) seperti Let's Encrypt, CA internal, atau Vault, dan mengelola proses validasi serta penerbitan sertifikat sesuai dengan kebutuhan.

  ```yaml
  apiVersion: cert-manager.io/v1
  kind: Issuer
  metadata:
    name: letsencrypt-production
    namespace: literature
  spec:
    acme:
      server: https://acme-v02.api.letsencrypt.org/directory
      email: ryhnalvr99@gmail.com
      privateKeySecretRef:
      name: letsencrypt-production
      solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token
                key: api-token
  ```
  Setelah domain tervalidasi, CA akan menerbitkan sertifikat, dan Cert-Manager akan menyimpannya sebagai Kubernetes secret
  
  ![image](https://github.com/user-attachments/assets/99c256ff-1e33-4f2d-9a81-f19fcbc49fb4)

- Buat konfigurasi untuk resource Certificate
  - Resource Certificate ini meminta Cert-Manager untuk mendapatkan wildcard certificate dari Issuer yang sudah kita buat tadi yaitu letsecnrypt-production.

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-cert
  namespace: literature
spec:
  secretName: wildcard-tls-secret
  issuerRef:
    name: letsencrypt-production
    kind: Issuer
  commonName: "*.alvaro.kubernetes.studentdumbways.my.id"
  dnsNames:
    - "*.alvaro.kubernetes.studentdumbways.my.id"
    - "alvaro.kubernetes.studentdumbways.my.id"
```

```
Sertifikat ini berlaku untuk semua subdomain dari alvaro.kubernetes.studentdumbways.my.id serta domain utama alvaro.kubernetes.studentdumbways.my.id.
Setelah sertifikat diterbitkan, Cert-Manager akan menyimpan sertifikat tersebut dalam secret yang disebut wildcard-tls-secret.
Secret ini yang nantinya kita gunakan untuk ingress kita nanti.
```

![image](https://github.com/user-attachments/assets/684ca057-ae82-4906-b09e-4278fa17ec0c)

## Buat Config Ingress untuk Frontend dan Backend

- Sebelumnya jangan lupa untuk membuat dns record dulu di cloudflare dan masukan IP salah satu worker
  - Tambahkan juga TLS certificate dari resource certificate yang sudah kita buat tadi dengan memasukan secret yang menampung certificate tersebut

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-ingress
  namespace: literature
spec:
  tls:
    - hosts:
        - alvaro.kubernetes.studentdumbways.my.id
      secretName: wildcard-tls-secret
  rules:
    - host: alvaro.kubernetes.studentdumbways.my.id
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-svc
                port:
                  number: 80
  ingressClassName: nginx
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend-ingress
  namespace: literature
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
    - hosts:
        - api.alvaro.kubernetes.studentdumbways.my.id
      secretName: wildcard-tls-secret
  rules:
    - host: api.alvaro.kubernetes.studentdumbways.my.id
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 5000
  ingressClassName: nginx
```

## Validasi aplikasi sudah berjalan on top kubernetes

![image](https://github.com/user-attachments/assets/02a345dd-1547-4cd8-b7bc-85a6b8c5fc66)

![image](https://github.com/user-attachments/assets/a70287e6-82e4-4861-8b49-f237d75d6e32)

![image](https://github.com/user-attachments/assets/8e8a7603-1227-4dab-b37f-2f00ace5cbfa)

![image](https://github.com/user-attachments/assets/7223de85-60c6-4545-a888-e70c34da0074)

![image](https://github.com/user-attachments/assets/3991f150-713a-4b0d-9d68-d84e8a2e1fe9)



