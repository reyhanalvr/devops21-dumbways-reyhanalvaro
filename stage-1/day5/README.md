# Day 5 Task

```
Task :

1. Jelaskan menurutmu apa perbandingan antara Application Monolith & Application Microservices
2. Deploy Aplikasi dumbflix-frontend (NodeJS)
3. Deploy Golang & Python dengan menampilkan nama masing-masing
4. Implementasikan penggunaan PM2 agar aplikasi kalian dapat berjalan di background

```

## 1. Perbandingan Aplikasi Monolith & Microservices

### 1.1 `Architecture`

- Monolith
  - Aplikasi monolith dibangun sebagai satu kesatuan tunggal yang besar. Semua komponen (seperti UI, Business Logic, dan Database) digabungkan dalam satu
  - Memiliki satu database tunggal yang digunakan oleh seluruh aplikasi

- Microservices
  - Aplikasi microservices dibagi menjadi beberapa services yang berdiri sendiri dan dapat di-deploy secara independen. Setiap layanan biasanya memiliki fungsi spesifik dan berkomunikasi satu sama lain melalui API.
  - Setiap layanan bisa memiliki database sendiri atau bisa juga berbagi database dengan layanan lain, tergantung pada desain dan kebutuhannya.

### 1.2 `Deployment dan Skalabilitas`

- Monolith
  - Ketika ada perubahan kecil dalam aplikasi, seluruh aplikasi harus di-deploy ulang. Ini bisa menjadi masalah jika aplikasi skalanya besar dan memerlukan waktu lama untuk build dan deploy
  - Skalabilitas biasanya dilakukan dengan menggandakan seluruh aplikasi, yang tidak akan efisien kalau hanya sebagian dari aplikasi yang memerlukan peningkatan kapasitas
  
- Microservices
  - Setiap layanan dapat di-deploy secara independen. Developer hanya perlu memodifikasi dan deploy bagian tertentu dari aplikasi yang ingin dilakukan perubahan.
  - Skalabilitas lebih fleksibel. Setiap layanan dapat ditingkatkan secara independen sesuai kebutuhan aplikasi

### 1.3 `Development Team`

- Monolith
  - Develop dan Maintenance bisa menjadi kompleks karena semua kode berada dalam satu basis kode besar. Ini dapat menyebabkan konflik dan ketergantungan yang tinggi di antara tim developer.
  - Biasanya dikelola oleh satu tim besar karena sifatnya yang terintegrasi satu sama lain.
    
- Microservices
  - Pengembangan lebih modular dan independen. Setiap layanan dapat dikembangkan, diuji, dan dipelihara oleh tim yang berbeda
  - emungkinkan pembagian tim menjadi tim-tim kecil yang fokus pada layanan tertentu

### 1.4 `Ketergantungan antar services`

- Monolith
  - Jika ada bug atau kesalahan dalam satu bagian aplikasi, itu bisa mempengaruhi seluruh aplikasi karena semuanya terintegrasi.
  - Memiliki ketergantungan antar bagian yang tinggi, sehingga perubahan di satu bagian bisa berdampak besar pada bagian lainnya.
  
- Microservices
  - Karena services terpisah satu sama lain, kegagalan dalam satu services tidak akan langsung mempengaruhi layanan lain.
  - Tetapi ini juga menambah kompleksitas dalam komunikasi antar services

### 1.5 `Teknologi yang digunakan`
- Monolith
  - Biasanya dibangun dengan satu tech atau stack yang digunakan secara konsisten di seluruh aplikasi.

- Microservices
  - Setiap services dapat dibangun dengan tech atau bahasa pemrograman yang berbeda, sesuai dengan kebutuhan spesifik layanan tersebut. Ini memungkinkan fleksibilitas teknologi yang lebih besar.

![image](https://github.com/user-attachments/assets/aec2c99b-aee2-4429-ab01-7f7848deb6bb)

## 2. Deploy Aplikasi Dumbflix

### 2.1 Git Clone Repository

![image](https://github.com/user-attachments/assets/cf4bf005-092e-4353-bb30-073e2000031e)

### 2.2 nvm Installation

![image](https://github.com/user-attachments/assets/1bda8cf9-0c0b-429e-bf21-7bdd562a3996)

![image](https://github.com/user-attachments/assets/12d8ecbb-b018-4a5e-86e9-a6a1b66eae35)

### 2.3 Melakukan npm install

![image](https://github.com/user-attachments/assets/2abf93ba-ec08-4755-9cb9-2eb2222a463a)


### 2.4 Jalankan aplikasi dengan 'npm start'

![image](https://github.com/user-attachments/assets/afe0df7a-6286-4430-a5a9-ce9864349742)

![image](https://github.com/user-attachments/assets/a5136542-08c6-4696-8cac-270c4514d557)

## 3. Deploy Aplikasi Python dan Golang

### Python

- Instalasi pip dan Flask

![image](https://github.com/user-attachments/assets/5d81520b-4d61-4a1c-a768-4769cd36c335)

![image](https://github.com/user-attachments/assets/042e23ab-fa06-4e91-8dbe-e3a3f0a52716)

- Buat file python dan masukan code
  
![image](https://github.com/user-attachments/assets/8f8e5e81-22e3-423d-88d4-3ee3af615069)

- Jalankan aplikasi dengan `python3 flask-app.py`

![image](https://github.com/user-attachments/assets/96430e8e-2b9f-4abc-86d2-c0c428c1028d)

![image](https://github.com/user-attachments/assets/a71e6681-040d-4f3d-884c-d457fa9d2b21)

### Golang

- Instalasi Golang

![image](https://github.com/user-attachments/assets/6586fa61-5982-4e88-9e32-2a54c0f05b80)

- Buat file go dan masukan code

![image](https://github.com/user-attachments/assets/5a208624-1255-44f6-b871-2eaba7a3a804)

- Jalankan aplikasi dengan `go run main.go`

![image](https://github.com/user-attachments/assets/26600fb8-7b77-4b6c-95fc-7671db9d860f)

![image](https://github.com/user-attachments/assets/28ead161-48f6-444a-a4d7-dce188561c6f)

## 4. Implementasi pm2 agar aplikasi berjalan di background

### 4.1 Instalasi pm2

![image](https://github.com/user-attachments/assets/2148e016-b630-4471-9118-43f986962b0c)

### 4.2 Implementasi untuk dumbflix-frontend di port 3000

![image](https://github.com/user-attachments/assets/9c31785d-b09f-4c94-93d0-6fba0daec985)

### 4.3 Implementasi untuk aplikasi python di port 5000

![image](https://github.com/user-attachments/assets/c366c021-0517-4559-8fb0-9bbf30156c2b)

### 4.4 Implementasi untuk aplikasi golang di port 3001

`Untuk golang sendiri kita harus build terlebih dahulu`

![image](https://github.com/user-attachments/assets/a005c50c-1f61-4c8e-87ff-692db10e1c46)

