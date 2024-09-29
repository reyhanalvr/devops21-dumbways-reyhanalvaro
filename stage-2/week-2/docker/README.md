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

# STAGING

## 1. Siapkan 1 server untuk environment staging

![image](https://github.com/user-attachments/assets/f8f4f86c-a045-4f64-9824-346db9aabc1c)

## 2. Buat User Baru dalam server - Team2

```
# Menambahkan user
sudo adduser team2-xxx

# Menambahkan user baru agar punya sudo (super user do)
sudo usermod -aG sudo team2-xxx

```

![image](https://github.com/user-attachments/assets/2d8a3b0f-c1f3-4f13-8fbb-b596cb1b011d)


## 3. Instalasi Docker dengan Bash Script di setiap server

Buat file .sh untuk menampung bash script
```bash
#!/bin/bash
#debug mode
set -x

sudo apt update

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
if [ $? -ne 0 ]; then
    echo "Failed to add Docker GPG key"
    exit 1
fi

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
if [ $? -ne 0 ]; then
    echo "Failed to add Docker repository"
    exit 1
fi

sudo apt update

sudo apt install -y docker-ce
if [ $? -ne 0 ]; then
    echo "Docker installation failed"
    exit 1
fi

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER

DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
if [ $? -ne 0 ]; then
    echo "Docker installation test failed"
    exit 1
fi

docker-compose --version
if [ $? -ne 0 ]; then
    echo "Docker Compose installation test failed"
    exit 1
fi

set +x
```

Jalankan `sudo chmod +x <nama_script.sh>`, perintah ini untuk membuat file script kita bisa di execute

Lalu running script dengan ./install_docker.sh

![image](https://github.com/user-attachments/assets/a5635a22-22c2-4e8e-8eef-200ae0e1ac92)

Periksa apakah docker sudah terinstall dalam server

![image](https://github.com/user-attachments/assets/1ab60898-ce16-4cef-9e98-ebb078f0cacb)

4. ## Deploy Frontend, Backend, Webserver, Database On Top Docker

- Git clone repository frontend dan backend
```
# Pull Frontend App
git clone https://github.com/dumbwaysdev/wayshub-frontend.git

# Pull Backend App
git clone https://github.com/dumbwaysdev/wayshub-backend.git

```

![image](https://github.com/user-attachments/assets/70e4cd7e-9ec5-47dd-9806-4e011e3f5e5e)

- Selanjutnya buat network untuk team-2
  ```
  # Untuk melihat docker network
  docker network ls

  # Untuk membuat docker network
  docker network create team2-network
  ```

![image](https://github.com/user-attachments/assets/99ee8b7c-66d6-4323-8a44-664ae7c94e41)

- Sebelum membuat docker compose, atur config di backend & frontend

![image](https://github.com/user-attachments/assets/7ebc8e62-561f-4175-ac63-d9ba068a12dc)

![image](https://github.com/user-attachments/assets/d41cdf4f-3b2d-4e3c-b71f-cd6b249c3298)

### Setup Database dan Backend terlebih dahulu
  ```dockerfile
services:
  db:
    image: mysql:5.7
    container_name: db_staging
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: Thebe@tles45
      MYSQL_DATABASE: literature
      MYSQL_USER: alvaro
      MYSQL_PASSWORD: Thebe@tles45
    volumes:
      - ./mysql:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - team2_network

  backend:
    build: ./literature-backend
    container_name: backend_staging
    environment:
      DB_USERNAME: alvaro
      DB_PASSWORD: Thebe@tles45
      DB_DATABASE: literature
      DB_HOST: 103.196.153.95
    ports:
      - "5000:5000"
    depends_on:
      - db
    networks:
      - team2_network

    networks:
    team2_network:
      driver: bridge
  ```

### Selanjutnya buat Dockerfile untuk Backend dan build image
  
  Jangan lupa tambahkan  `RUN npx sequelize db:migrate` di Dockerfile untuk migrate database

  ![image](https://github.com/user-attachments/assets/fd68e1e8-8fa3-4110-b444-badaf34f006e)

  ```
  # Membuat image docker
  docker build -t team2/literature/backend:staging .
  ```

### Setelah images backend selesai dibuat kita bisa jalankan aplikasi backend dan database

![image](https://github.com/user-attachments/assets/63d05196-fc8f-42c3-8604-f9c31872d4fe)

![image](https://github.com/user-attachments/assets/ba70a489-6d4c-4572-99a4-f42f84e2418e)

  

