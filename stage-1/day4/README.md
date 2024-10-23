# Day 4

```
Task : 
1. Menurutmu apa itu Git ?
2. Gambarkan menurut kalian flow dari cara kerja Git ini seperti apa?
3. Buatlah Dokumentasi tentang Command yang ada di Git (boleh di tambahkan beberapa command yang mungkin belum kita pelajari pada saat pembahasan di kelas)
4. Study Case
Ada 2 Developer yang sedang melakukan development aplikasi dari perusahaan A sebut saja Reyhan dan Teguh mereka kebetulan sedang mengerjakan suatu proyek yang sama, dan mereka sedang mengerjakan file yang sama index.html.
Reyhan membuat perubahan pada file index.html dan melakukan commit: git add index.html; git commit -m "fix: Typo on Description". Teguh kebetulan juga membuat perubahan pada index.html dan melakukan commit: git add index.html ; git commit -m "feat: Header Adjustment".
Kemudia disini ternyata Reyhan melakukan push ke repository. Teguh, yang belum melakukan push, mencoba untuk melakukan push ke repositori.
Karena ternyata ada perubahan baru di remote yang belum dimiliki Teguh, Git menolak push Teguh dan memberi tahu bahwa ada konflik.
Disini Teguh harus melakukan Fix Conflict tersebut agar perubahan yang di buat oleh Teguh dapat tersimpan ke dalam repositori app tersebut. lalu bagaimana cara menangani case yang dimiliki oleh Teguh?
```

## 1. Git

GIT adalah version control system terdistribusi yang digunakan untuk melacak perubahan dalam kode selama pengembangan aplikasi. Git dikenal juga dengan distributed revision control (VCS terdistribusi), artinya penyimpanan database Git tidak hanya berada dalam satu tempat saja. Dengan menggunakan Git, programmer dapat mengedit kode dengan membuat cabang yang terpisah dari versi utama, sehingga tim dapat mengedit kode sendiri-sendiri tanpa mengganggu kode utama. Setelah selesai, perubahan yang dilakukan pada cabang tersebut dapat digabungkan kembali ke versi utama secara aman

![image](https://github.com/user-attachments/assets/fac5422d-ba53-406b-9834-9fe5a4b51aeb)


### `Fitur Utama Git`
- ` Distribusi:` GIT bersifat terdistribusi, artinya setiap developer memiliki salinan lengkap dari seluruh repositori, termasuk perubahan dari setiap kodenya. Ini memungkinkan pengembang untuk bekerja secara offline dan melakukan commit sebelum mendorong perubahan ke repositori pusat.
- `Branching dan Merging:` GIT memudahkan untuk membuat branch dari repositori utama, yang memungkinkan para developer aplikasi untuk mengerjakan fitur baru atau perbaikan bug tanpa mengganggu branch utama. Setelah selesai, branch dapat digabungkan atau merged kembali ke cabang utama.
- `Version History:` GIT dapat melacak setiap perubahan yang dilakukan pada proyek, memungkinkan developer untuk kembali ke versi sebelumnya, membandingkan perubahan, dan memahami history pengembangan aplikasi secara detail.

## 2. Git Workflow

![image](https://github.com/user-attachments/assets/e600c622-e3a7-4fe0-866c-b3cdca2adb3a)

### 1. Clone Repository - `git clone <repository_url>` -> Developer melakukan clone remote repository ke local mereka. 
### 2. Membuat Branch baru - `git checkout -b <nama_branch>` ->  Developer membuat branch baru untuk mengerjakan fitur atau perbaikan tertentu, sehingga perubahan yang dilakukan tidak akan tercampur dari branch utama.
### 3. Developer melakukan perubahan pada code pada branch local mereka
### 4. Stage Changes - `git add <file>` -> Developer mempersiapkan perubahan di stage agar bisa di commit
### 5. Commit Changes - `git commit -m "Pesan Commit"` -> Developer melakukan commit dari perubahan yang sudah di stage ke branch local.
### 6. Push ke remote repository - `git push origin <nama_branch>` -> Perubahan yang sudah di-commit di-push ke branch yang sesuai di remote repository.
### 7. Mengajukan Pull Request -> Pull request dibuat untuk mengusulkan penggabungan branch baru ke dalam branch utama.
### 8. Merge -`git checkout main & git merge <nama_branch>` ->  Setelah pull request disetujui, perubahan di-merge ke branch utama.
### 9. Pull dari repositori utama - `git pull origin main` -> Developer melakukan pull untuk melihat perubahan terbaru dari branch utama ke local mereka untuk tetap sinkron dan up to date.

## 3. Git Command

### 3.1 `git init`

Memulai repository Git baru di direktori saat ini. Ini membuat subdirektori .git yang menyimpan semua objek dan referensi yang dibutuhkan untuk versi kontrol.

![image](https://github.com/user-attachments/assets/9fdb754a-de8c-474d-aa66-5b840af04cf3)

### 3.2 `git add`

Menambahkan semua perubahan file (baru, yang diubah, atau dihapus) ke staging area.

![image](https://github.com/user-attachments/assets/59aae475-a9ff-4e9a-8639-eb364c31b76e)

### 3.3 `git commit`

Membuat commit dengan semua perubahan yang ada di staging area, dan menambahkan pesan commit yang menjelaskan perubahan tersebut.

![image](https://github.com/user-attachments/assets/264ea088-dd0b-4db0-889b-481c3534b195)

### 3.4 `git push`

Mengirim commit yang ada di branch lokal main ke remote repository origin.

![image](https://github.com/user-attachments/assets/a760e966-6c00-4f82-86d7-700161f40be6)

### 3.5 `git status`

Menampilkan status dari working directory dan staging area. Ini menunjukkan file mana yang diubah, ditambahkan, atau dihapus, serta file yang belum ditambahkan ke staging area.

![image](https://github.com/user-attachments/assets/95ec8319-cfd2-4548-86a8-d1782cfa1d79)

### 3.6 `git branch`

Menampilkan semua branch yang ada di repository, termasuk yang ada di remote repository (-a menunjukkan semua branch, lokal dan remote).
Command `git branch` bisa untuk membuat branch baru.

![image](https://github.com/user-attachments/assets/cffd07f0-1f1b-4f79-9581-ade1ecb9db0c)

![image](https://github.com/user-attachments/assets/64850ee9-15cf-45fa-9964-dec718e7d8ee)

### 3.7 `git checkout`

Beralih ke branch lain bernama feature-branch. Branch ini bisa merupakan branch yang sudah ada atau bisa juga digunakan untuk membuat branch baru (git checkout -b <branch_baru>).

![image](https://github.com/user-attachments/assets/8dc569eb-0535-44eb-8878-219eae5148e3)

### 3.8 `git merge` 

Menggabungkan perubahan dari branch lain ke branch aktif saat ini. Ini sering digunakan untuk menggabungkan pekerjaan dari branch yang berbeda.

![image](https://github.com/user-attachments/assets/db47914d-27a3-4b1f-be80-dd163bddd32c)

### 3.9 `git log`

`git log --oneline`

Menampilkan riwayat commit dari repository. Ini menunjukkan daftar commit yang pernah dibuat, lengkap dengan hash, pesan commit, dan detail lainnya.

![image](https://github.com/user-attachments/assets/1d13e6a9-0e98-481b-81bd-44e818303630)

### 3.10 `git remote`

Digunakan untuk mengelola dan menampilkan informasi tentang remote repository yang terhubung dengan repository lokal.
 
![image](https://github.com/user-attachments/assets/9b9d15dc-276b-4aa4-9889-2f835b582098)

### 3.11 `git pull`

Mengambil perubahan terbaru dari remote repository dan langsung menggabungkannya dengan branch aktif lokal.

![image](https://github.com/user-attachments/assets/d6502443-dcdc-41c4-ad09-89c761ea6f11)

## 4. Study Case

Langkah yang harus dilakukan teguh :
### 1. Teguh harus melakukan pull dengan command `git pull` dari remote repository ke repository localnya untuk menggabungkan code yang sudah dipush oleh Reyhan
` git pull origin <nama_branch>`

![image](https://github.com/user-attachments/assets/34be721d-6e2e-4749-8ea6-3ba67eae86d1)

## 2. Mengatasi konflik, Teguh perlu membuka file index.html dan melihat teks konflik yang ditambahkan oleh Git

```
<<<<<<< HEAD 
<p>Perubahan Teguh</p>
=======
<p>Perubahan Reyhan</p>
>>>>>>> <perubahan_reyhan> 
```

Bagian di antara <<<<<<< HEAD dan ======= adalah perubahan yang dilakukan oleh Teguh, sementara bagian di antara ======= dan >>>>>>> <perubahan_reyhan> adalah perubahan yang dibuat oleh Reyhan. Setelah melihat perubahannya, Teguh bisa melakukan perubahan dan menambahkan perubahan dari Reyhan. Setelah melakukan perubahan, Teguh harus menyimpan filenya

## 3. Melakukan Commit

Setelah tidak ada konflik, Teguh perlu melakukan commit

![image](https://github.com/user-attachments/assets/fbedbed9-4ccb-4b45-a557-b33abd2aaae2)

## 4. Push file yang sudah di commit

Setelah commit, Teguh dapat mencoba untuk melakukan push kembali

![image](https://github.com/user-attachments/assets/e7420adc-4854-4de0-822e-105f8f02c0eb)
