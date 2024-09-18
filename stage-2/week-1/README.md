
Tasks :

- Install nginx
- Buatlah reverse proxy dan gunakan domain dengan nama kalian ex:
  - frontend : randal.studentdumbways.my.id
  - ssl cloudflare boleh Active / atau ingin menggunakan SSL certbot juga dipersilahkan
  - backend : api.randal.studentdumbways.my.id
    - untuk Installation Certbot ada banyak cara (salah 1 nya seperti pada saat di kelas), atau kalau kalian menemukan cara lain untuk melakukan installation certbot atau tools yang lain yang digunakan untuk melakukan             generate ssl feel free to use yaa.
    - Generate SSL untuk reverse proxy kalian.
    - Sedikit chalange coba cari bagaimana cara pengimplementasian Wildcard SSL
Happy Explore :))

---

# Install nginx

![image](https://github.com/user-attachments/assets/6d67f999-9399-400a-be83-0cd26a657c37)

![image](https://github.com/user-attachments/assets/3ea6978c-e9f1-4efe-8d0b-64a7a57b9977)

# Buat Reverse Proxy dengan domain nama 

## Backend

### Konfigurasi Reverse Proxy
![image](https://github.com/user-attachments/assets/afeccdce-22ea-46b8-8869-d8a3dac9bfd0)

### DNS Management 
![image](https://github.com/user-attachments/assets/80b45694-c373-46ca-bd7e-32ac794d66ec)

### Reverse Proxy Berhasil
![image](https://github.com/user-attachments/assets/6dbd24dd-22ac-4178-92b1-8fbdc8157f00)

## Frontend

### Konfigurasi Reverse Proxy
![image](https://github.com/user-attachments/assets/07c078cc-532f-4d43-9cb7-faf5f8975168)

### DNS Management 
![image](https://github.com/user-attachments/assets/3afee2a0-5681-4872-b18a-a85ce33c30be)

### Reverse Proxy Berhasil
![image](https://github.com/user-attachments/assets/0c007fdd-40e3-48d1-b920-1806f4cf154e)

## Instalasi SSL dengan Certbot

### Instalasi SSL
![image](https://github.com/user-attachments/assets/4091a9d5-439f-4f6e-8e5a-ba89897283f3)

### Website sudah terinstall SSL

![image](https://github.com/user-attachments/assets/c015d72a-ad1d-4cdb-b948-f977ef03179e)

## Implementasi Wildcard SSL

### Buat direktori untuk konfigurasi

![image](https://github.com/user-attachments/assets/8ce88859-db64-4044-97cb-7feaef18e2bf)

### Buat file konfigurasi di dalamnya & Atur Permssion chmod 400

![image](https://github.com/user-attachments/assets/89ba9dc9-7e78-438b-9ccb-d2944cdd6022)

### Dapatkan Wildcard SSL dengan perintah

`sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secret/config.ini -d *.alvaro.studentdumbways.my.id -d alvaro.studentdumbways.my.id`

![image](https://github.com/user-attachments/assets/9f7ba8bd-5212-4072-8a84-eeea7618f732)

![image](https://github.com/user-attachments/assets/39256847-c103-41dd-a643-e8cc830c1dd9)





