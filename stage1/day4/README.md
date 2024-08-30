# Day 4

```
Task : 
1. Menurutmu apa itu Git ?
2. Gambarkan menurut kalian flow dari cara kerja Git ini seperti apa?
3. Buatlah Dokumentasi tentang Command yang ada di Git (boleh di tambahkan beberapa command yang mungkin belum kita pelajari pada saat pembahasan di kelas)
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

