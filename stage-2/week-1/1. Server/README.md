```
Requirment:
Appserver for deploying Database
Gateway for deploying Frontend Application, Backend Application, And Web Server

Tasks :

Create new user for all of your server
The server only can login with SSH-KEY without using password at all

```

# 1. Konfigurasi Untuk Login Menggunakan SSH-KEY

---

### 1. Simpan SSH-KEY dari cloud

![image](https://github.com/user-attachments/assets/ee47b3b5-c708-4907-8036-5103b75635ef)

### 2. Konfigurasi sshd_config -> Uncommand PubKey Authentication & Password Authentication
![image](https://github.com/user-attachments/assets/297909a4-070f-447f-bc0e-83c26fee1082)


![image](https://github.com/user-attachments/assets/82d4a39b-a463-4fba-a482-01c1bbf35812)


![image](https://github.com/user-attachments/assets/16293531-36f2-4e16-ab72-3df17ce3230a)

### 3. Khusus Ubuntu 22 Keatas, ada konfigurasi tambahan

![image](https://github.com/user-attachments/assets/a434292e-6501-4fe9-8de7-3a20b17b477d)

![image](https://github.com/user-attachments/assets/8f6463c1-ed80-4133-9891-f4e29c3b10ac)

### 4. Restart ssh service 

![image](https://github.com/user-attachments/assets/529ce482-5df8-4711-a4b3-467c5a31f5ff)

### 5. Pembuktian sudah bisa login dengan ssh-key dan tanpa password

![image](https://github.com/user-attachments/assets/b002db2b-9f6b-4ff9-8371-41954aade701)

![image](https://github.com/user-attachments/assets/fc280c30-a1d2-4dba-8b6c-3ff1e78078b4)

# 2. Buat user untuk setiap server

## Pembuatan User di gateway server

![image](https://github.com/user-attachments/assets/164333c9-14f1-4cf8-a1df-65803991c0b6)

![image](https://github.com/user-attachments/assets/5e7eaa07-b4ce-474c-ab1c-61e510b98bb9)

## Pembuatan User di apps server

![image](https://github.com/user-attachments/assets/d8aed5b1-ad19-4250-bffe-578b6b930923)

