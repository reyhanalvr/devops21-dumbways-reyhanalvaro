# PRODUCTION 

## 1. Siapkan 4 buah server untuk environment production

![image](https://github.com/user-attachments/assets/ad179359-ab88-4b5a-a885-57a39c66218f)


![image](https://github.com/user-attachments/assets/b05736c5-2f00-4389-b990-ee1562621c35)

## 2. Buat User Baru Untuk Setiap Server - Team2

```
# Menambahkan user
sudo adduser team2-xxx

# Menambahkan user baru agar punya sudo (super user do)
sudo usermod -aG sudo team2-xxx

```

### Server Database

![image](https://github.com/user-attachments/assets/53243045-eded-4ff4-b5cd-ce7ba2edd490)

### Server Backend

![image](https://github.com/user-attachments/assets/68a4a99a-0912-44a2-8481-9e2dc8e6971f)

### Server Frontend

![image](https://github.com/user-attachments/assets/cf6e4eb9-3236-4e72-9c59-5c850269e052)

### Webserver

![image](https://github.com/user-attachments/assets/410ef30c-4bae-456d-b69a-bb5384ad7a17)


## 3. Instalasi Docker dengan Bash Script di setiap server

Buat file .sh untuk menampung bash script

Jalankan `sudo chmod +x <nama_script.sh>`, perintah ini untuk membuat file script kita bisa di execute

![image](https://github.com/user-attachments/assets/53032673-17ad-475f-a5fd-c35f6c1b5f0e)

Untuk menjalankan skrip bisa menggunakan 

```
# run script
sudo sh install-docker.sh

# atau
sudo ./install-docker.sh

```

Setelah skrip diexecute, exit dan masuk kembali lalu cek apakah docker sudah terinstall

![image](https://github.com/user-attachments/assets/7abdd496-6f79-46ae-9660-c4f441cf663d)

--- 
--- 
--- 

## 4. Server Database

- Buat direktori untuk dijadikan volume

![image](https://github.com/user-attachments/assets/198071f8-75d6-4d9b-8582-03261c682a60)

- Buat docker-compose.yaml di server database, jangan lupa untuk pasang volume yang sudah kita buat tadi

![image](https://github.com/user-attachments/assets/a0930550-90f0-4f84-8fe3-09eaee966fe8)

- Menjalankan docker compose dengan perintah:

```
docker compose up -d
```

- Check apakah container sudah berjalan dengan sukses

![image](https://github.com/user-attachments/assets/e1d280c4-8f0a-47aa-9257-0f96877d8d22)

- Untuk pembuktiannya kita akan masuk ke database dan user yang sudah kita buat tadi

Untuk masuk ke container kita, gunakan perintah ini

```
docker compose exec db bash
```

![image](https://github.com/user-attachments/assets/d6bc65e7-25fc-428f-9412-88f375f771d2)

---
---
---

## 5. Server Backend

- Konfigurasikan backend agar dapat terhubung ke database kita tadi
  
![image](https://github.com/user-attachments/assets/76495bf2-4926-4a2b-bdc4-12fd53498dd1)

- Di file package.json, saya menambahkan script untuk menjalankan migrate database dengan sequelize-cli

```package.json
  "scripts": {
    "start": "nodemon server.js",
    "migrate": "sequelize-cli db:migrate"
  }
```

- Buat Dockerfile untuk build image | Pastikan size image sekecil mungkin dengan multistage build
 
 Disini saya menggunakan node-16:alpine

 ```dockerfile
FROM node:16-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN npm install nodemon

COPY . .

RUN npm run migrate


#Build

FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app .

CMD ["npm", "start"]

EXPOSE 5000
```
 
![image](https://github.com/user-attachments/assets/b0d0b6ab-3244-4424-9bfb-957fb1e4bdf3)

- Build image yang sudah dibuat

```bash

docker build -t team2/literature/backend:production . 

```

![image](https://github.com/user-attachments/assets/e9f197f2-38e3-4121-9c0f-1785b65b40fb)


- Buat file compose untuk mengkonfigurasi layanan-layanan yang dibutuhkan dalam aplikasi dan menjalankannya dengan satu perintah

Ini isi script docker-compose.yaml untuk container backend

```yaml
services:

  literature-be:
    image: team2/literature/backend:production
    restart: always
    environment:
      DB_USERNAME: team2
      DB_PASSWORD: Thebe@tles45
      DB_DATABASE: literature
      DB_HOST: 103.196.153.76
    ports:
      - "5000:5000"
```

- Jalankan script compose dengan perintah dan check apakah sudah berjalan 
  ```
  # Command untuk running compose file
  docker compose up -d

  # Command untuk melihat process status dari docker compose
  docker compose ps -a
  ```
![image](https://github.com/user-attachments/assets/a7c9702d-f04d-4b90-af7e-437a16ce17e7)

---
---
---

## 6. Server Frontend

- Konfigurasikan Frontend agar bisa terhubung dengan Backend
  
![image](https://github.com/user-attachments/assets/70ac72d8-3c83-4ef6-904a-79411ab75762)

- Buat Dockerfile untuk build image | Pastikan size image sekecil mungkin dengan multistage build

  Disini saya menggunakan node-16:alpine
  
```dockerfile
FROM node:16-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app .

EXPOSE 3000

CMD [ "npm", "start" ]
```

- Lalu building image untuk frontend
  
```bash

docker build -t team2/literature/frontend:production . 

```

![image](https://github.com/user-attachments/assets/93d85d65-7393-44c5-96ee-a5f4e53b7650)

- Buat file compose untuk mengkonfigurasi layanan-layanan yang dibutuhkan dalam aplikasi dan menjalankannya dengan satu perintah

Ini isi script docker-compose.yaml untuk container frontend

```yaml
services:
  frontend:
    image: team2/literature/frontend:production
    container_name: literature-frontend
    ports:
      - "3000:3000"
    restart: always
    stdin_open: true
```

- Jalankan script compose dengan perintah dan check apakah sudah berjalan 
  ```
  # Command untuk running compose file
  docker compose up -d

  # Command untuk melihat process status dari docker compose
  docker compose ps -a
  ```

  ![image](https://github.com/user-attachments/assets/2f1cbf5c-6402-435e-9de2-d98fc2a12dd6)

  ---
  ---
  ---

## 7. Webserver

- Konfigurasi Reverse Proxy Nginx

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name team2.studentdumbways.my.id;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name team2.studentdumbways.my.id;

        ssl_certificate /etc/nginx/ssl/fullchain.pem;
        ssl_certificate_key /etc/nginx/ssl/privkey.pem; # Pastikan ini sesuai dengan volume yang di-mount

        location / {
            proxy_pass http://103.127.136.49:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    server {
        listen 443 ssl;
        server_name api.team2.studentdumbways.my.id;

        ssl_certificate /etc/nginx/ssl/fullchain.pem;  # Pastikan ini sesuai dengan volume yang di-mount
        ssl_certificate_key /etc/nginx/ssl/privkey.pem; # Pastikan ini sesuai dengan volume yang di-mount

        location / {
            proxy_pass http://103.127.136.47:5000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

- Lakukan Wildcard SSL dengan Certbot
  - Sebelumnya saya membuat direktori .secret dan membuat file config.ini dengan isi dns cloudflare api token

  Lalu jalankan command ini untuk mendapatkan certificate ssl
  
```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secret/config.ini -d *.team2.studentdumbways.my.id -d team2.studentdumbways.my.id 

```

- Buat file docker compose untuk webserver

![image](https://github.com/user-attachments/assets/348cf379-b179-4e24-9071-41db4b8c825f)

- Jalankan script compose dengan perintah dan check apakah sudah berjalan 
  ```
  # Command untuk running compose file
  docker compose up -d

  # Command untuk melihat process status dari docker compose
  docker compose ps -a
  ```
![image](https://github.com/user-attachments/assets/17b54269-9f28-4909-8755-35df9f7ed572)


## Pembuktian kalau aplikasi kita sudah berjalan


![image](https://github.com/user-attachments/assets/7607f767-9f9d-494e-90f5-e07856546ef9)

![image](https://github.com/user-attachments/assets/5cd0ba7d-6533-4f17-8ea4-d7832b715b9e)

## Pembuktian kalau aplikasi sudah terintegrasi satu sama lain antar service

![image](https://github.com/user-attachments/assets/fc934562-f357-4e53-bd55-c436da177c79)

![image](https://github.com/user-attachments/assets/f5c2f04c-f06f-4b63-976b-489e4f32b8ff)

