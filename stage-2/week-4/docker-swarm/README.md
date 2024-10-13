```
Docker Swarm Tasks

1. Buatlah sebuah cluster menggunakan Docker Swarm yang berisikan minimal 3 buah node (1 master, 2 worker).
2. Deploy aplikasi yang sudah pernah kalian gunakan di materi" sebelumnya, seperti dumbflix, wayshub, literature.(pilih salah satu saja).
3. Diharapkan aplikasi bisa berjalan 100% on top Docker Swarm.
4. Untuk reverse proxy bisa menyesuaikan. Diperbolehkan menggunakan ssl dari cloudflare, maupun di generate sendiri.
```

# Siapkan 3 buah server 

![image](https://github.com/user-attachments/assets/3e154c23-045f-4e70-8393-81d70992d4a2)

# Lakukan docker swarm initiation pada node yang akan dijadikan master

```
docker swarm init --advertise-addr <ip_address>
```

![image](https://github.com/user-attachments/assets/70e7ceca-36f2-46cd-b1aa-24f0fa5a3927)

Ketika kita melakukan initiation, maka muncul output seperti 

` docker swarm join --token `

Copy command tersebut beserta token untuk join

# Lakukan docker swarm join dari hasil output swarm init tadi ke server yang akan dijadikan worker

![image](https://github.com/user-attachments/assets/3e4c1f88-c811-497e-af06-080e6875aced)

Jika sudah tinggal cek di node master, dengan command

```
docker node ls
```

![image](https://github.com/user-attachments/assets/980d5c5b-204f-4a58-86d7-9e070ec59618)

# Siapkan image yang sudah dipush ke registry

![image](https://github.com/user-attachments/assets/03bba36e-9249-4564-b014-e81ac3007db2)

Disini saya pakai 1 compose file yang sama untuk setiap service, dan juga berkoneksi di 1 network overlay dengan scope swarm

![image](https://github.com/user-attachments/assets/bbd3a956-7994-4fe4-aa48-dc9302c00481)


### Command pada docker swarm

```
docker service ls (Melihat List Service Running) 
docker service ps <service> (Melihat Proccess Status Service)
docker service logs -f <service> (Melihat Logs Service)
docker service scale <service>=2 (Menambah replica)
docker service update --replicas 1 <nama_service>
docker service rm  <service> (Menghapus Service)

docker stack deploy --compose-file docker-compose.yml literature (Menjalankan docker compose)

```


# Deploy Database mysql

Jangan lupa untuk buat volume untuk mysql

```yaml
services:
  mysql:
    image: mysql:5.7
    networks:
      - app_network
    volumes:
      - ./mysql/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: 
      MYSQL_DATABASE: 
      MYSQL_USER: 
      MYSQL_PASSWORD: 
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 1
        delay: 10s
    ports:
      - "3306:3306"
```
![image](https://github.com/user-attachments/assets/9baa1786-c28a-4cfb-a56e-c2c6206bc243)

` docker service ps literature_mysql` untuk melihat process status dari service database kita

![image](https://github.com/user-attachments/assets/b26dd341-bde7-4ba8-b966-5ba71334e513)


# Deploy Backend Literature

Disini saya membuat 3 replica untuk backend

```yaml
  backend:
    image: reyhanalvr/literature-be:swarm
    depends_on:
      - mysql
    networks:
      - app_network
    ports:
      - "5000:5000"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
```

Sebelum masuk ke frontend, lakukan db migrate terlebih dahulu untuk mengetahui database kita sudah terhubung apa belum


![image](https://github.com/user-attachments/assets/d67ddcb1-cec4-4e6d-8f28-7174d87f6ff9)

![image](https://github.com/user-attachments/assets/945e61d1-7e40-4f2b-bb7f-710e8e9919a9)

Jika database yang dimasukan pada config sudah terbuat dan sesuai maka db:migrate akan berhasil

![image](https://github.com/user-attachments/assets/74ee3117-1c2c-460d-9cd0-2708ea07cb24)

` docker service ps literature_backend` untuk melihat process status dari service backend kita

![image](https://github.com/user-attachments/assets/a8cbd981-7c1d-4069-9cb5-381df3aded98)


# Deploy Frontend Literature

Setelah database dan backend di deploy dan sudah terhubung, kita lakukan deploy frontend

Sama seperti backend disini saya membuat 3 replica untuk frontend juga

```yaml
  frontend:
    image: reyhanalvr/literature-fe:swarmV3
    stdin_open: true
    depends_on:
      - mysql
      - backend
    networks:
      - app_network
    ports:
      - "3000:80"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
```
` docker service ps literature_frontend` untuk melihat process status dari service frontend kita

![image](https://github.com/user-attachments/assets/be2f377c-755b-45a7-b9b9-9d5cd43c019b)


# Reverse Proxy + SSL Certbot

Sebelum membuat reverse proxy, kita generate terlebih dahulu ssl wildcard dengan certbot

Konfigurasi Reverse Proxy

```bash
events {
    worker_connections 1024;
}

http {
    # Upstream untuk frontend cluster
    upstream frontend_cluster {
        server 103.196.153.95:3000 max_fails=3 fail_timeout=30s weight=5;
        server 103.127.136.47:3000 max_fails=3 fail_timeout=30s weight=4;
        server 3.1.90.43:3000 max_fails=3 fail_timeout=30s backup;
    }

    # Upstream untuk backend cluster
    upstream backend_cluster {
        server 103.196.153.95:5000 max_fails=3 fail_timeout=30s weight=5;
        server 103.127.136.47:5000 max_fails=3 fail_timeout=30s weight=4;
        server 3.1.90.43:5000 max_fails=3 fail_timeout=30s backup;
    }

    # Redirect HTTP to HTTPS for frontend
    server {
        listen 80;
        server_name fe.alvaroo.studentdumbways.my.id;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    # Redirect HTTP to HTTPS for backend
    server {
        listen 80;
        server_name be.alvaroo.studentdumbways.my.id;

        location / {
            return 301 https://$host$request_uri;
        }
    }

    # HTTPS for frontend
    server {
        listen 443 ssl;
        server_name fe.alvaroo.studentdumbways.my.id;

        ssl_certificate /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/privkey.pem;

        location / {
            proxy_pass http://frontend_cluster;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    # HTTPS for backend
    server {
        listen 443 ssl;
        server_name be.alvaroo.studentdumbways.my.id;

        ssl_certificate /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/privkey.pem;

        location / {
            proxy_pass http://backend_cluster;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

Docker Compose

```yaml
  nginx:
    image: nginx:latest
    networks:
      - app_network
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/fullchain.pem:/etc/letsencrypt/live/alvaroo.studentdumbways.my.id/fullchain.pem
      - /etc/letsencrypt/live/alvaroo.studentdumbways.my.id/privkey.pem:/etc/letsencrypt/live/alvaroo.studentdumbways.my.id/privkey.pem
    ports:
      - "443:443"
      - "80:80"
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == manager]
      restart_policy:
        condition: on-failure
```

# Setelah itu check apakah service kita sudah berjalan dan juga coba buka di website aplikasi kita

```
docker service ls
```

![image](https://github.com/user-attachments/assets/92578717-eb74-4d44-9492-f50709fe624e)

![image](https://github.com/user-attachments/assets/3056f350-4fe0-4f05-9232-5c9920f5c1fd)

![image](https://github.com/user-attachments/assets/a75cf156-be6d-4a0e-9294-68e6c8be35cb)

![image](https://github.com/user-attachments/assets/82a3840c-6f02-41c2-b47b-b6713f3f0513)

![image](https://github.com/user-attachments/assets/284cef51-88c3-49ef-8c0c-ac4ec8d815e4)

![image](https://github.com/user-attachments/assets/3cb89ea9-22a0-4429-bec2-eda087b34f35)

