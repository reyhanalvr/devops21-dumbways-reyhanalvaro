# Task

```
Gunakan vm Appserver kalian diskusikan saja ingin menggunakan vm siapa di dalam team

Repository && Reference:
Literature Backend
Literature Frontend
Certbot
PM2 Runtime With Docker

Tasks :
[ Docker ]

Buatlah suatu user baru dengan nama team kalian

Buatlah bash script se freestyle mungkin untuk melakukan installasi docker.

Deploy aplikasi Web Server, Frontend, Backend, serta Database on top docker compose

Ketentuan buatlah 2 environment yaitu (staging dan production)

Ketentuan di Staging

Buat suatu docker compose yang berisi beberapa service kalian - Web Server - Frontend - Backend - Database
Untuk penamaan image, sesuaikan dengan environment masing masing, ex: team1/dumbflx/frontend:staging
Di dalam docker-compose file buat suatu custom network dengan nama team kalian, lalu pasang ke setiap service yang kalian miliki.
Deploy database terlebih dahulu menggunakan mysql dan jangan lupa untuk pasang volume di bagian database.
Ketentuan di Production

Deploy database di server terpisah
Server Backend terpisah dengan 2 container di dalamnya
Server Frontend terpisah dengan 2 container di dalamnya
Web Server juga terpisah untuk reverse proxy kalian nantinya.
Untuk penamaan image, sesuaikan dengan environment masing masing, ex: team1/dumbflx/frontend:production
Untuk building image frontend dan backend sebisa mungkin buat dockerized dengan image sekecil mungkin(gunakan multistage build). dan jangan lupa untuk sesuaikan configuration dari backend ke database maupun frontend ke backend sebelum di build menjadi docker images.

Untuk Web Server buatlah configurasi reverse-proxy menggunakan nginx on top docker.

SSL CLOUDFLARE OFF!!!
Gunakan docker volume untuk membuat reverse proxy
SSL gunakan wildcard
Untuk DNS bisa sesuaikan seperti contoh di bawah ini
Staging
Frontend: team1.staging.studentdumbways.my.id
Backend: api.team1.staging.studentdumbways.my.id
Production
Frontend: team1.studentdumbways.my.id
Backend: api.team1.studentdumbways.my.id
Push image ke docker registry kalian masing".

Aplikasi dapat berjalan dengan sesuai seperti melakukan login/register.
```

