![image](https://github.com/user-attachments/assets/41af667b-79cd-4a11-b9ae-b8da5de053f5)# Day 3
 
```
Task :

1. Buatlah Dokumentasi tentang ShortCut dari Text Editor Nano yang kamu ketahui!
2. Buatlah Dokumentasi tentang Manipulation Text yang kamu ketahui
3. Apa perbedaan Shell Script dan Bash Script ?
4. Buatlah Bash Script untuk melakukan installasi webserver, dengan kebutuhan case: jika user menginputkan nomor 1 maka dia akan melakukan installasi WebServer Nginx dan jika user menginputkan nomor 2 maka akan melakukan installasi WebServer Apache2
5. Implementasikan Firewall pada linux server kalian.
    - Buatlah 2 buah Virtual Machine.
    - Study case nya adalah agar hanya server A yang hanya dapat mengakses WebServer yang ada pada server B.
    - Carilah cara agar UFW dapat memblokir ataupun mengizinkan specific protocol jaringan seperti TCP dan UDP.
    - Jelaskan perbedaan protocol Jaringan TCP serta UDP.

```

# 1. Dokumentasi Shortcut Nano

``` ^ = Ctrl | M = Alt ```

## 1.1 Navigasi dan Editing
- `Ctrl + A: Pindah ke awal baris`
- `Ctrl + E: Pindah ke akhir baris`
- `Ctrl + K: Cut teks dari posisi kursor awal ke akhir baris (atau keseluruhan baris jika kursor di awal baris)`
- `Ctrl + W: Mencari teks dalam file`
- `Ctrl + \:Mengganti teks dalam file`
- `Ctrl + _ : pindah ke baris dan kolom spesifik` 

![image](https://github.com/user-attachments/assets/239505b1-23b6-482e-8cdb-853c6cfb89db)

### `Mencari teks`

![image](https://github.com/user-attachments/assets/d52b5094-c036-464e-866c-592dddf193c3)

### `Mengganti teks`
![image](https://github.com/user-attachments/assets/2b231da6-8750-4088-820e-a0c10ca08723)

![image](https://github.com/user-attachments/assets/63e9c3ac-2c75-4d94-b6d9-c01441635c75)

![image](https://github.com/user-attachments/assets/2fe94a16-7b64-4cd0-a889-d7a7da1e7de7)

## 1.2 Save & Exit
- `Ctrl + O: Menyimpan file tanpa harus keluar teks editor.`
- `Ctrl + X: Menyimpan file dan keluar dari teks editor nano.`
- `Ctrl + R: Masukkan konten dari file lain ke dalam file yang sedang dibuka | Ctrl + T: jika ingin melihat file apa saja dalam direktori kita` 

![image](https://github.com/user-attachments/assets/821413e0-0ea7-4484-8052-858042a6fec8)

![image](https://github.com/user-attachments/assets/59b61deb-3ccb-4452-bfd1-5de891168da5)

## 1.3 Help Shortcut

- `Ctrl + G: Menampilkan daftar halaman bantuan pada teks editor`

![image](https://github.com/user-attachments/assets/9b0f914a-28b8-4fa3-87f6-047940964c42)

## 1.4 Undo & Redo
- `Ctrl + U: Batalkan perubahan (undo).`
- `Ctrl + E: Ulangi perubahan yang dibatalkan (redo).`


# 2. Dokumentasi tentang Manipulation Text

## 1.`cat`

- `cat > <namafile> : untuk membuat file baru dan menginput teks | bisa juga untuk merewrite file yang sudah ada`

![image](https://github.com/user-attachments/assets/3655188f-45d5-4f47-8811-3b3da4ee9482)

- `cat >> <namafile> : untuk append/menambahkan teks baru`

![image](https://github.com/user-attachments/assets/df945375-310b-4a8b-9a5a-8eff83b8426d)

- `cat <file1> <file2> > <file_baru> : untuk menggabungkan 2 file menjadi 1 file baru`

![image](https://github.com/user-attachments/assets/29a0fd3e-44f3-4641-b373-2cab075d8faa)

## 2. `sed`

- ` sed -i 's/kata/katapengganti/g' <namafile> ` -> /g disini global (global replacement) untuk secara spesifik mengganti string dalam kalimat
  
![image](https://github.com/user-attachments/assets/7cedb3c8-e74c-4e47-8488-c4025731d056)

- ` sed -i 's/kata/pengganti/1/2' <namafile>` -> /1 /2 disini untuk mengganti kata pada kalimat ke-n di setiap barisnya.

![image](https://github.com/user-attachments/assets/47798537-9d6b-45a0-b1e0-c57be8ef5ce6)

- `sed -i '/pattern/d' <namafile>` -> untuk menghapus kata pada file

![image](https://github.com/user-attachments/assets/247cd4b4-d842-4434-96db-2572e40d11db)

- ` 'sed -i '$a\Teks Baru' <namafile>' ` -> untuk menambahkan baris baru pada akhir file

![image](https://github.com/user-attachments/assets/a9455659-caf4-45eb-a1d1-40fb18069881)

## 3. 'awk'

- ` awk '/pattern/ {print}' <filename> ` -> print output sesuai pattern yang diinput

![image](https://github.com/user-attachments/assets/997f79b2-416c-42e6-b975-27d5b6add9e0)

- ` awk '{print $n,$n}' <filename> ` > print output yang sudah disiplit sesuai n kedalam line baru

![image](https://github.com/user-attachments/assets/32c7afb7-1e8d-4e45-ab7d-cded9899d52b)

![image](https://github.com/user-attachments/assets/c1ba9d07-3d3b-42c2-883d-f1f3a4eea243)


## 4. 'grep'

- `grep <kata> <namafile>`

![image](https://github.com/user-attachments/assets/d3774c60-5085-4918-8371-d6eff7612a93)

- `grep -r(recursive) <kata>` -> mencari kata tetapi lupa direktorinya dimana

![image](https://github.com/user-attachments/assets/13b88292-5bd6-4330-8a86-2911a12b4fbb)

- `grep -rl <kata>` -> mencari file/direktori dengan kata

![image](https://github.com/user-attachments/assets/1d1f2bea-8cc8-484c-b8b4-67762101c685)

  
  
