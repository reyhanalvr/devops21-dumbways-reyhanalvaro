```

Tasks :

- Setup node-exporter, prometheus dan Grafana menggunakan docker / native diperbolehkan
- monitoring seluruh server yang kalian buat di materi terraform dan yang kalian miliki di biznet.
- Reverse Proxy
  bebas ingin menggunakan nginx native / docker
- Domain
  exporter-$name.studentdumbways.my.id (node exporter)
  prom-$name.studentdumbways.my.id (prometheus)
  monitoring-$name.studentdumbways.my.id (grafana)
- SSL Cloufflare on / certbot SSL biasa / wildcard SSL diperbolehkan
Dengan Grafana, buatlah :
- Dashboard untuk monitor resource server (CPU, RAM & Disk Usage) buatlah se freestyle kalian.
- Buat dokumentasi tentang rumus promql yang kalian gunakan
- Buat alerting dengan Contact Point pilihan kalian (discord, telegram, slack dkk)
Untuk alert :
Boleh menggunakan alert manager / alert rule dari grafana
Ketentuan alerting yang harus dibuat
CPU Usage over 20%
RAM Usage over 75%
- Monitoring specific container
- deploy application frontend di app-server
  monitoring frontend container
untuk alerting bisa di check di server discord yaa, sudah di buatkan channel alerting

```

## Setup Node Exporter, Prometheus, dan Grafana menggunakan docker dengan bantuan ansible

Prometheus, Grafana, Node Exporter di server monitoring
![image](https://github.com/user-attachments/assets/dcdcba45-6ad9-4e79-a33d-8944d7ef3c6c)

Node Exporter di semua server
![image](https://github.com/user-attachments/assets/dd9421ab-9dcf-4ba6-ba24-1e713088047c)

## Reverse Proxy menggunakan docker & Pasang SSL Certbot

Script Ansible

```bash
    - name: Stop Nginx for Certbot
      docker_container:
        name: nginx
        state: stopped

    - name: Create Cloudflare credentials file
      copy:
        dest: /srv/nginx/cloudflare.ini
        content: |
          dns_cloudflare_api_token = {{dns_cloudflare_api_token}}
        mode: '0600'    

    - name: Check if SSL certificate exists
      stat:
        path: /etc/letsencrypt/live/alvaro.studentdumbways.my.id/fullchain.pem
      register: cert_status

    - name: Obtain wildcard SSL certificates using Certbot
      command: >
        certbot certonly --dns-cloudflare --dns-cloudflare-credentials /srv/nginx/cloudflare.ini
        -d *.alvaro.studentdumbways.my.id 
        --email ryhnalvr99@gmail.com 
        --agree-tos
      when: not cert_status.stat.exists

    - name: Update Nginx reverse proxy config with SSL for monitoring
      template:
        src: reverse_proxy_certbot.conf.j2
        dest: /srv/nginx/conf.d/multi_domain_proxy.conf
        owner: root
        group: root
        mode: '0644'

    - name: Update Nginx reverse proxy config with SSL for frontend
      template:
        src: reverse_proxy_certbot_fe.conf.j2
        dest: /srv/nginx/conf.d/frontend.conf
        owner: root
        group: root
        mode: '0644'  
        
    - name: Run Nginx container
      docker_container:
        name: nginx
        image: nginx:latest
        state: started
        restart_policy: always
        ports:
          - "80:80"
          - "443:443"
        volumes:
          - /srv/nginx/conf.d:/etc/nginx/conf.d
          - /srv/nginx/logs:/var/log/nginx
          - /etc/letsencrypt/live/alvaro.studentdumbways.my.id/fullchain.pem:/etc/nginx/ssl/fullchain.pem
          - /etc/letsencrypt/live/alvaro.studentdumbways.my.id/privkey.pem:/etc/nginx/ssl/privkey.pem
```

![image](https://github.com/user-attachments/assets/b04f29ef-341c-43b5-a11a-96ab920ef8b9)

![image](https://github.com/user-attachments/assets/03f9e878-7453-49bb-ac99-5107ddd961cd)

![image](https://github.com/user-attachments/assets/9f429f8b-2473-4624-8240-a40a48594816)

## Buat prometheus.yml 

Prometheus.yml adalah file konfigurasi utama untuk Prometheus, sebuah sistem monitoring yang digunakan untuk mengumpulkan dan menganalisis data metrics dari berbagai sumber. File ini mendefinisikan bagaimana Prometheus akan menjalankan proses pengumpulan data (scraping), sumber mana yang akan dipantau, dan berbagai pengaturan terkait lainnya.

```
global:
  scrape_interval: 30s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ["exporter4.alvaro.studentdumbways.my.id"]

  - job_name: 'all-server'
    static_configs:
      - targets:
        - "exporter1.alvaro.studentdumbways.my.id"
        - "exporter2.alvaro.studentdumbways.my.id"
        - "exporter3.alvaro.studentdumbways.my.id"
        - "exporter4.alvaro.studentdumbways.my.id"

  - job_name: 'aws'
    static_configs:
      - targets:
        - "exporter1.alvaro.studentdumbways.my.id"
        - "exporter2.alvaro.studentdumbways.my.id"

  - job_name: 'biznet'
    static_configs:
      - targets:
        - "exporter3.alvaro.studentdumbways.my.id"
        - "exporter4.alvaro.studentdumbways.my.id"

  - job_name: 'cadvisor'
    scrape_interval: 15s
    static_configs:
      - targets:
        - "13.250.0.217:8080"
        - "13.251.32.98:8080"
        - "103.127.136.47:8080"
        - "103.196.153.95:8080"
```

Dapat dilihat saya memiliki berbagai job dan sumber untuk dianalisa nantinya di grafana.

![image](https://github.com/user-attachments/assets/904180d0-0ac6-4eb0-ac5d-733c02e95696)


## Monitoring Dashboard

![image](https://github.com/user-attachments/assets/9fd07e66-a9c6-4992-9793-78aa3d6a75eb)

Pada dashboard saya terdapat beberapa informasi terkait penggunaan cpu, memory, fs, disk.

## Rumus PromQL yang digunakan

### Memory Usage

```
100 - ((node_memory_MemAvailable_bytes{instance="$node",job="$job"} * 100) / node_memory_MemTotal_bytes{instance="$node",job="$job"})
```

Menghitung persentase penggunaan memori  pada sebuah server dengan mengurangi jumlah memori yang tersedia dari total memori yang ada, dan kemudian mengkonversinya menjadi persentase



### CPU Usage

```
(((count(count(node_cpu_seconds_total{instance="$node",job="$job"}) by (cpu))) - avg(sum by (mode)(irate(node_cpu_seconds_total{mode='idle',instance="$node",job="$job"}[5m])))) * 100) / count(count(node_cpu_seconds_total{instance="$node",job="$job"}) by (cpu))
```

Menghitung persentase penggunaan CPU pada sebuah server. Rumus ini memperhitungkan waktu idle CPU untuk menentukan berapa banyak CPU yang sedang aktif digunakan dibandingkan total CPU yang tersedia.


## Buat Alerting

![image](https://github.com/user-attachments/assets/a14282e2-b922-47a1-aa7b-5e74af839cd8)

### CPU Usage Alert

Ketika CPU pemakaiannya diatas 20% maka akan dikirimkan alert ke discord

![image](https://github.com/user-attachments/assets/cb77d5f9-dd49-4652-a1d9-8ce437c4fb43)

### Memory Usage Alert

Ketika Memory pemakaiannya diatas 75% maka akan dikirimkan alert ke discord

![image](https://github.com/user-attachments/assets/77c992f9-2ba7-42df-a73f-b09fcfcd14bc)

![image](https://github.com/user-attachments/assets/8c50e592-6f9b-417b-a316-cabbcf478d72)

![image](https://github.com/user-attachments/assets/acaf01b6-85f3-41b5-99f7-f1ada98a952f)


