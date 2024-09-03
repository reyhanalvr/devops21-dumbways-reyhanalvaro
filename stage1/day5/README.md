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
