# Day 6 Task

```
Task :

1. Jelaskan apa itu Web server dan gambarkan bagaimana cara webserver bekerja.
2. Buatlah Reverse Proxy untuk aplilkasi yang sudah kalian deploy kemarin. ( dumbflix-frontend) dan implementasikan penggunaan pm2 di aplikasi tersebut, untuk domain nya sesuaikan nama masing" ex: alvin.xyz .
3. Jelaskan apa itu load balance.
4. implementasikan loadbalancing kepada aplikasi dumbflix-frontend yang telah kalian gunakan.

```

## 2. Buat Reverse Proxy untuk aplikasi dumbflix

### `Saya menjalankan aplikasi dari server 1 dengan ip 192.168.239.134, aplikasi sendiri berjalan di port 3000`

### 2.1 Masuk ke `/etc/nginx` dan buat folder untuk menampung reverse proxy

![image](https://github.com/user-attachments/assets/fd104399-ca0a-4bf1-a04d-d1a0fc45bad0)

### 2.2 Buat file konfigurasi untuk reverse proxy

![image](https://github.com/user-attachments/assets/65a8fa68-089d-494b-ab76-f79e5e8b95eb)

### 2.3 Check apakah ada error dan reload/restart nginx 

![image](https://github.com/user-attachments/assets/5c553ce9-1871-4057-8f3c-48bd695092b0)

### 2.4 Tambahkan DNS ke server 
![image](https://github.com/user-attachments/assets/5dd980a0-e7b6-417a-bf09-a87bb28d6a9b)

Seharusnya reverse proxy kita sudah berhasil untuk pembuktiannya saya akan membuka aplikasi di Windows

### 2.5 Buka file hosts di windows dan tambahkan dns & ip webserver

![image](https://github.com/user-attachments/assets/ef013267-2905-4474-8c7c-b3c6e45ede37)

![image](https://github.com/user-attachments/assets/cb5e0759-380e-44bb-927a-9ce6dac2c9ba)

### 2.6 Pembuktian reverse proxy sudah berhasil 

![image](https://github.com/user-attachments/assets/48bf4caa-cdd5-4f06-b372-92b8a5232a7a)


## 4. Implementasi load balance 

### `Saya menjalankan aplikasi di 2 server berbeda dengan ip 192.168.239.134 dan 192.168.239.135. Aplikasi berjalan di port 3000`

### 4.1 Jalankan aplikasi di 2 server

![image](https://github.com/user-attachments/assets/5777a481-65a7-490f-8f83-fc06377b56a1)

### 4.2 Setting konfigurasi load balance

### `disini saya menambahkan weight, max_fails, dan fails_timeout`
![image](https://github.com/user-attachments/assets/88eefb0c-41ec-45c9-8550-e0972ec08998)


## 4.3 Reload nginx

![image](https://github.com/user-attachments/assets/8694b103-0523-4e5b-b187-aefc26c2236e)

![image](https://github.com/user-attachments/assets/75ccfeab-58ae-4e6b-bb6d-a9095aa9dae3)

## 4.4 Aplikasi bisa diakses

![image](https://github.com/user-attachments/assets/8ddfc383-15b1-4d59-89ee-ac6ad648b3c2)

## 4.5 Jika salah satu server aplikasi mati, aplikasi masih bisa diakses

![image](https://github.com/user-attachments/assets/7d7e407b-7dc6-4165-97f7-234b92e84e7a)

## 4.6 Jika semua server mati, aplikasi tidak bisa diakses

![image](https://github.com/user-attachments/assets/d71ca869-cf19-47f9-9e93-39ac8d645ada)


