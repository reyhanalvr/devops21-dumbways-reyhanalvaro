```sh
Task :
1. Buatlah Dokumentasi tentang Linux Command yang kamu ketahui!
2. Jelaskan Perbedaan antara IP Private & Public, serta IP Dynamic & Static!
```

# 1. **Dokumentasi Linux Command**

Berikut adalah beberapa perintah Linux yang saya ketahui :

### 1. `ls`
Perintah `ls` atau list digunakan untuk menampilkan daftar file dan direktori dalam direktori saat ini.

ls -l \n
ls -a

![image](https://github.com/user-attachments/assets/caf57fa0-0943-41b6-9b4f-94e6c0b29945)

### 2. `cd`
Perintah `cd` atau change directory untuk berpindah direktori

cd .. ( berpindah ke direktory sebelumnya )
cd / ( untuk masuk ke root )
![image](https://github.com/user-attachments/assets/fa2e6401-6147-4103-9ff6-2dc622929b12)

### 3. `mkdir`
Perintah `mkdir` atau make directory untuk membuat direktori baru/folder baru

![image](https://github.com/user-attachments/assets/25f64b22-3585-4416-94ea-a771b3c56be1)


### 4. `rmdir`
Perintah `rmdir` atau remove directory untuk menghapus direktori yang sudah ada
![image](https://github.com/user-attachments/assets/4b9022ff-194d-40ea-94e5-c3896d426a6d)

### 5. `touch`
Perintah `touch` digunakan untuk membuat file baru
![image](https://github.com/user-attachments/assets/3d6bde35-e658-4e98-b8c0-06d90e135112)

### 6. `rm`
perintah `rm` atau remove digunakan untuk menghapus file
![image](https://github.com/user-attachments/assets/d6d9258c-deb7-40de-a494-3ff44c4b6222)

### 7. `cp`
perintah `cp` atau copy digunakan untuk menyalin file/direktori 

perintah cp juga bisa digunakan menyalin sekaligus mengganti nama file

![image](https://github.com/user-attachments/assets/0bc499d6-550e-4897-b600-add2ee6cd271)

![image](https://github.com/user-attachments/assets/8a5f2ee3-30a9-4e10-bb44-507f73b53ec6)

### 8. `mv`
perintah `mv` atau move digunakan untuk memindahkan file ke direktori lain

perintah mv juga bisa digunakan untuk mengubah nama pada direktori yang sama

![image](https://github.com/user-attachments/assets/e6ab5d1b-491d-4b6e-802b-c9148c150303)

![image](https://github.com/user-attachments/assets/08f65fdf-737c-439f-b5cb-93d2fd57f2a0)

### 9. `grep`
perintah `grep` digunakan untuk mencari kata pada file atau output tertentu 

contoh penggunaan 
history | grep "teks-yang-akan-dicari"
grep "teks" alvaro.js

### 10. `sudo`
Perintah sudo di Linux digunakan untuk menjalankan perintah dengan hak akses pengguna lain, biasanya sebagai pengguna root. Nama sudo berasal dari singkatan "superuser do." Perintah ini memberikan kemampuan kepada pengguna untuk menjalankan perintah yang membutuhkan hak akses administratif tanpa harus masuk sebagai pengguna root.

![image](https://github.com/user-attachments/assets/2be5718d-c780-4506-9589-98f0dbe84f30)

### 11. `chmod`
Perintah `chmod` digunakan untuk mengubah izin akses file atau direktori.

```
chmod numeric
read (r)= 4
write (w)= 2
execute = 1

```
![image](https://github.com/user-attachments/assets/e9af4b5a-7a28-4bc4-97d6-7a3a187daf43)


### 12. `chown`

Perintah `chown` digunakan untuk mengubah pemilik file atau direktori.

![image](https://github.com/user-attachments/assets/2fd0853d-50b4-4f77-97bf-650a5042611b)

### 13. `ip route`

Perintah `ip route` digunakan untuk menampilkan dan mengkonfigurasi tabel routing IP di sistem Linux.
IP route juga bisa digunakan untuk menambah/menghapus rute jaringan

### 14. `ip address`
Perintah `ip address` digunakan untuk menampilkan dan mengkonfigurasi alamat IP pada interface jaringan di sistem Linux.

### 15. `find`
Perintah `find` di Linux digunakan untuk mencari file dan direktori dalam sistem file

![image](https://github.com/user-attachments/assets/9dbf14a0-586f-4eb6-a97a-6b7f899c9004)

### 16. `nano`
Perintah `nano` berfungsi untuk menampilkan file dalam teks editor nano, jikalau file belum ada maka nano akan membuatnya

![image](https://github.com/user-attachments/assets/d7d09630-5f83-4575-aca2-b465b7d15a12)

![image](https://github.com/user-attachments/assets/9dfabe2d-e212-47e3-ad3e-12f9d23371ad)

### 17. `history`
Perintah `history` untuk melihat riwayat perintah yang sudah kita gunakan sebelumnya. 

![image](https://github.com/user-attachments/assets/cf136bba-c92a-4c5c-8741-823495e657f6)

### 18. `echo`
Perintah `echo` berfungsi untuk menambahkan suatu teks kedalam file

```
echo > untuk rewrite/menulis ulang isi dari file tersebut
echo >> untuk append teks ke dalam file tanpa menghapus teks sebelumnya

```
![image](https://github.com/user-attachments/assets/288bb80d-8b6d-453d-aafe-85f3dabde9a8)

### 19. `adduser`
Perintah `adduser` berfungsi untuk menambahkan user baru pada sistem linux.

![image](https://github.com/user-attachments/assets/4d97a525-2eb3-4f2d-8d8c-085d5aed406f)

### 20. `sudo su`
Perintah `sudo su` digunakan saat kita ingin meminta akses sebagai root, perintah ini juga bisa berfungsi untuk berpindah pada user lain di sistem kita.

![image](https://github.com/user-attachments/assets/2c0af90b-55e9-4cb9-97dd-05fe54058c38)



# 2. **Perbedaan antara IP Private & Public, serta IP Dynamic & Static**


### `IP Private`

`IP Private` adalah alamat IP yang digunakan dalam jaringan lokal dan tidak dapat diakses langsung dari internet. IP ini digunakan untuk perangkat yang terhubung dalam jaringan internal.
Biasanya IP Private digunakan dalam sebuah jaringan rumah atau kantor, IP Private juga tidak bisa diakses secara langsung dari luar

```
Contoh IP Private:

- 192.168.0.0 – 192.168.255.255
- 172.16.0.0 – 172.31.255.255
- 10.0.0.0 – 10.255.255.255
```
### `IP Public`

`IP Public` adalah alamat IP yang digunakan untuk mengidentifikasi perangkat pada jaringan publik. IP ini diberikan oleh ISP dan dapat diakses dari mana saja melalui internet.
IP Public juga bisa digunakan untuk berkomunikasi dengan perangkat lain di internet

```
Contoh IP Public
- 8.8.8.8
- 1.1.1.1

```

---
### `IP Dynamic`
`IP Dynamic` adalah alamat IP yang diberikan oleh server DHCP (Dynamic Host Configuration Protocol) dan dapat berubah-ubah setiap kali perangkat terhubung ke jaringan.

```
Kelebihan:

- Pengelolaan lebih mudah.
- Tidak membutuhkan konfigurasi manual.

Kekurangan:

- IP dapat berubah, sehingga tidak cocok untuk server yang membutuhkan alamat tetap.
```

### `IP Static`
IP Static adalah alamat IP yang ditetapkan secara manual dan tidak berubah kecuali diubah secara manual oleh administrator.

```
Kelebihan:

- IP tetap, cocok untuk server dan perangkat yang membutuhkan alamat konstan/tidak berubah-ubah.

Kekurangan:

- Membutuhkan konfigurasi manual dan lebih sulit dikelola jika ada banyak perangkat.
```

