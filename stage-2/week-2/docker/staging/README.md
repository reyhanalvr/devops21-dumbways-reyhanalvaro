
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

## 4. Deploy Frontend, Backend, Webserver, Database On Top Docker

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

# Setup Database dan Backend

### Buat volumes untuk mysql

![image](https://github.com/user-attachments/assets/7cb1a844-dbad-476d-bc5d-e9c48cae1f88)

### Buat docker-compose.yml untuk BE dan DB 

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


# Setup Frontend dan Nginx 

### Buat Dockerfile untuk Frontend

![image](https://github.com/user-attachments/assets/2f314bad-5cbe-48ff-a066-f8bad357a627)

### Build Image Frontend

  ```
  # Membuat image docker
  docker build -t team2/literature/frontend:staging .
  ```
![image](https://github.com/user-attachments/assets/c459b185-600f-490b-8940-fe39fe9d091f)

### Buat direktori nginx untuk volume

![image](https://github.com/user-attachments/assets/a2577ef5-9415-4fdf-bb08-b6437c3e6b55)

Lalu buat reverse proxy untuk aplikasi kita dengan domain yang sudah dibuat di cloudflare 

![image](https://github.com/user-attachments/assets/9ed48b2e-90a5-40ea-93f6-2ff28bac5de7)

### Setelah melakukan setup awal, tambahkan config ke docker-compose.yml tadi

```dockerfile
  frontend:
    build: ./literature-frontend
    container_name: frontend_staging
    stdin_open: true
    ports:
      - "3000:3000"
    depends_on:
      - backend
      - db
    networks:
      - team2_network

  nginx:
    image: nginx:latest
    container_name: nginx_staging
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - /etc/letsencrypt/live/team2.staging.studentdumbways.my.id/fullchain.pem:/etc/nginx/ssl/fullchain.pem
      - /etc/letsencrypt/live/team2.staging.studentdumbways.my.id/privkey.pem:/etc/nginx/ssl/privkey.pem
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - frontend
      - backend
    networks:
      - team2_network
```

### Jalankan docker compose

```
# Command untuk running compose file
docker compose up -d

# Command untuk melihat process status dari docker compose
docker compose ps -a
```

![image](https://github.com/user-attachments/assets/18a4f67f-2457-48b4-919e-1cc7624a6e53)

### Implementasi Wilcard SSL

Untuk SSL certificate Wildcard saya menggunakan Certbot untuk generate satu kali SSL sertificate yang nantinya bisa di gunakan untuk semua SSL.

```
sudo snap install --classic certbot

sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo snap set certbot trust-plugin-with-root=ok

sudo snap install certbot-dns-cloudflare

```

Setup Credential cloudflare terlebih dahulu dan simpan ke dalam file cloudflare.ini di lokasi /root/.secret/cloudflare.ini

```bash
dns_cloudflare_email = "emailname@gmail.com"
dns_cloudflare_api_key = "Token isi Here"
```

```
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d team2.staging.studentdumbways.my.id -d *.team2.staging.studentdumbways.my.id --preferred-challenges dns-01
```


### Setelah itu cek apakah aplikasinya berjalan atau tidak

![image](https://github.com/user-attachments/assets/a86703f4-5cf1-40c2-b5bd-e14a5b7d1f00)

![image](https://github.com/user-attachments/assets/39d3d8f8-c1d5-48b7-b325-521d8bb2354b)

![image](https://github.com/user-attachments/assets/563ec2b8-db7f-4b75-8b8e-36871bffaff4)

![image](https://github.com/user-attachments/assets/c78e2f80-6b19-429e-b131-ec8f08aa0da4)
