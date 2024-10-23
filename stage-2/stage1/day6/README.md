# Day 6 Task

```
Task :

1. Jelaskan apa itu Web server dan gambarkan bagaimana cara webserver bekerja.
2. Buatlah Reverse Proxy untuk aplilkasi yang sudah kalian deploy kemarin. ( dumbflix-frontend) dan implementasikan penggunaan pm2 di aplikasi tersebut, untuk domain nya sesuaikan nama masing" ex: alvin.xyz .
3. Jelaskan apa itu load balance.
4. implementasikan loadbalancing kepada aplikasi dumbflix-frontend yang telah kalian gunakan.

```
## 1. Apa itu Web Server?

Web server adalah perangkat yang bertugas menyimpan, memproses, dan mengirimkan data kepada user melalui protokol HTTP/HTTPS. Fungsinya adalah menerima request dari client/user, kemudian mengirimkan respons dalam bentuk halaman web atau data yang diakses. Contoh web server yang biasa dipakai adalah nginx, apache, litespeed, caddy, lighttpd, dsb.

### Fungsi Web Server

### 1.1 Melindungi Keamanan Sistem
  - Kehadiran web server bisa memperkuat security dari sebuah website. Hal ini bisa terjadi berkat adanya fitur seperti TLS atau SSL encryption, autentikasi, dan sertifikat digital.

### 1.2 Menjadi Penyimpan Log Server
  - Server akan mencatat semua aktivitas terjadi seperti kesalahan, request pengguna, dan lain sebagainya. Data log ini nantinya akan sangat berguna untuk penyebab masalah dan analisis pada masalah yang ada di server.
    
### 1.3 Menampilkan konten pada website
  - Karena memiliki fungsi sebagai pusat penyimpanan, maka server juga berperan untuk menyajikan konten website. Saat ada user yang mengakses website, sistem akan mengambil halaman website yang nantinya akan memberi response lewat protokol HTTP atau HTTPS

### 1.4 Penyedia Akses ke Database
  - Server akan berperan untuk menghubungkan aplikasi website dengan database. Artinya, website bisa mengambil data dari database untuk kemudian ditampilkan kepada pengguna web.

### 1.4 Bertanggung Jawab untuk Load Balancing 
  - Fungsi web server lainnya adalah load balancing. Tujuan load balancing adalah agar user tidak harus menunggu lama ketika mengakses website dan memastikan pengelolaan sumber daya server efisien.

### Cara kerja web server 

![image](https://github.com/user-attachments/assets/f61541a1-269e-4609-bfb6-867cfc25c518)


- User memasukan sebuah url ke dalam browser (client)
- Browser akan mengirimkan HTTP request kepada web server
- Web Server akan menerima HTTP request dan memprosesnya. Jika diperlukan, web server mengakses database atau aplikasi backend lainnya untuk memproses request secara dynamic.
- Web Server akan mengirimkan HTTP response berupa file atau data yang diminta kembali ke browser.
- Terakhir, halaman website pun akan muncul kepada pengguna di browser yang user gunakan. Tampilannya akan sesuai dengan pengaturan yang sudah web developer tetapkan. 


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

## 3. Apa itu Load balancing?

Load balancing adalah teknik yang digunakan untuk mendistribusikan lalu lintas jaringan atau beban kerja ke beberapa server atau sumber daya, sehingga tidak ada satu server yang kelebihan beban. Tujuan utamanya adalah untuk memastikan bahwa setiap server bekerja secara optimal, mengurangi kemungkinan terjadinya downtime, dan meningkatkan kinerja serta ketersediaan layanan.

### Manfaat load balancing

### - Meningkatkan ketersediaan (Availability)
  - Jika salah satu server mengalami kegagalan, load balancer akan mengarahkan permintaan ke server yang masih berfungsi. Dengan begitu, load balancing dapat membantu mengurangi downtime dan meningkatkan ketersediaan sistem secara keseluruhan.
    
### - Meningkatkan kinerja 
  - Dengan mendistribusikan beban secara merata, server tidak akan kelebihan beban, yang dapat meningkatkan kecepatan respons layanan.
    
### - Skalabilitas (Scalability)
  - Mudah menambah server baru tanpa mengganggu layanan yang sedang berjalan.
    
### - Redundansi 
  - Load balancer dapat dikonfigurasi untuk mengarahkan trafik ke server cadangan/backup jika server utama mengalami masalah. Ini memungkinkan adanya tingkat redundansi yang tinggi dalam infrastruktur.


![image](https://github.com/user-attachments/assets/d8d828e1-bd42-4480-8f29-46ead8e0fc0c)

Seperti contoh gambar diatas, saat pengguna mengklik URL di browser mereka, load bolancer akan menentukan server mana yang tersedia untuk memproses request dari client dan kemudian mengalihkan trafik ke server tersebut. Hal ini untuk memastikan tidak ada server yang kewalahan dari sisi trafficnya.

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


