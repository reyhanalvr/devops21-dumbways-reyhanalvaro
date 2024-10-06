```
Ansible

[Local]
Buat konfigurasi Ansible & sebisa mungkin maksimalkan penggunaan ansbile untuk melakukan semua setup dan se freestyle kalian

[ansible]
Buatlah ansible untuk :

- Membuat user baru, gunakan login ssh key & password
- Instalasi Docker
- Deploy application frontend yang sudah kalian gunakan sebelumnya menggunakan ansible.
- Instalasi Monitoring Server (node exporter, prometheus, grafana)
- Setup reverse-proxy
- Generated SSL certificate
simpan script kalian ke dalam github dengan format tree sebagai berikut:
  Automation  
  |  
  | Terraform
  └─|   └── gcp
       │   └── main.tf
       │    └── providers.tf
       │    └── etc
       │   ├── aws
       │    └── main.tf
       │    └── providers.tf
       │    └── etc
       │  ├── azure
       │    └── main.tf
       │    └── providers.tf
       │    └── etc
    Ansible
    ├── ansible.cfg
    ├── lolrandom1.yaml
    ├── group_vars
    │ └── all
    ├── Inventory
    ├── lolrandom2.yaml
    └── lolrandom3.yaml

```

# Install Ansible

![image](https://github.com/user-attachments/assets/de5db14d-d2fd-4c76-b49d-cfc26fd2a9d2)

# Buat Inventory dan ansible.cfg

Inventory
Inventory dalam Ansible adalah file yang berisi daftar dari server atau node yang akan dikelola, bisa juga disebut host.

![image](https://github.com/user-attachments/assets/f2d22c80-2a7a-4454-a11c-fe4c97c58121)

ansible.cfg
ansible.cfg adalah file konfigurasi utama Ansible yang mengatur berbagai pengaturan default untuk eksekusi playbook dan command Ansible lainnya. File ini berfungsi untuk memudahkan pengaturan dan menyesuaikan Ansible secara global.

![image](https://github.com/user-attachments/assets/ea703540-d14c-4886-a5da-2327d8ce18d2)


# Ansible Roles

Ansible Roles adalah fitur dalam Ansible yang memungkinkan kita untuk mengatur dan mengelola playbooks dalam struktur yang lebih modular dan mudah dikelola. Dengan menggunakan roles, kita dapat membagi konfigurasi Ansible menjadi beberapa bagian kecil yang lebih terorganisir, sehingga lebih mudah untuk memahami, maintenance, dan menggunakan kembali.

![image](https://github.com/user-attachments/assets/d5a14524-28c0-40da-bfa6-846cf89c8ece)

Keuntungan Menggunakan Roles:
- Organisasi yang Baik: Membantu mengorganisasi playbooks yang besar dan kompleks menjadi lebih modular.
- Reuseability: Roles bisa digunakan kembali di beberapa playbook atau proyek tanpa menulis ulang konfigurasi yang sama.
- Skalabilitas: Dengan struktur yang rapi, roles memudahkan pengelolaan infrastruktur dalam skala besar.
- Maintenability: Memudahkan pemeliharaan dan modifikasi playbook karena struktur yang lebih teratur dan modular.

Sebelumnya, jangan lupa untuk membuat variable yang nantinya akan kita panggil dalam konfigurasi ansible kita. Pada kali ini, saya membuat variable global maupun variable sesuai dengan roles.

# Ansible Vault

Ansible Vault adalah fitur dalam Ansible yang memungkinkan kitaa untuk mengenkripsi data sensitif, seperti kata sandi, kunci SSH, API tokens, atau informasi lain yang tidak ingin disimpan dalam bentuk teks biasa di playbook atau file konfigurasi. Dengan Ansible Vault, kita bisa mengenkripsi dan mendekripsi file, dan hanya pengguna yang memiliki kunci yang tepat yang bisa melihat atau menggunakan isinya.

![image](https://github.com/user-attachments/assets/14d5f41b-99af-4742-8fef-fa31d8e699cc)

## Membuat user baru

```bash
---
# tasks file for roles/user

- name: Install acl package
  apt:
    name: acl
    state: present

- name: Create user
  user:
    name: "{{ user_name }}"
    state: present
    home: "/home/{{ user_name }}"
    shell: /bin/bash
    create_home: yes

- name: Add user to sudo group
  user:
    name: "{{ user_name }}"
    groups: sudo
    append: yes 

- name: Add user to docker group
  user:
    name: "{{ user_name }}"
    groups: docker
    append: yes

- name: Set user password
  user:
    name: "{{ user_name }}"
    password: "{{ user_password | password_hash('sha512') }}"
  # no_log: true

- name: Set user home directory permissions
  file:
    path: "/home/{{ user_name }}"
    mode: '0755'

- name: Set user shell
  shell: chsh -s /bin/bash {{ user_name }}
  environment:
    HOME: "/home/{{ user_name }}"

- name: Add SSH public key
  authorized_key:
    user: "{{ user_name }}"
    key: "{{ ssh_public_key }}"
    state: present
    path: "/home/{{ user_name }}/.ssh/authorized_keys"

- name: Ensure .ssh directory exists
  file:
    path: "/home/{{ user_name }}/.ssh"
    state: directory
    mode: '0700'
    owner: "{{ user_name }}"
    group: "{{ user_name }}"

- name: Set permissions for authorized_keys
  file:
    path: "/home/{{ user_name }}/.ssh/authorized_keys"
    mode: '0600'
    owner: "{{ user_name }}"
    group: "{{ user_name }}"

```

![image](https://github.com/user-attachments/assets/c30e5c3b-5622-48f5-a9eb-493b2903bbe2)


## Instalasi Docker

```bash
---
# tasks file for roles/docker

- name: Update apt cache
  apt:
    update_cache: yes

- name: Install required packages for Debian
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
    state: present
  when: ansible_os_family == "Debian"

- name: Install required packages for Ubuntu
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
    state: present
  when: ansible_os_family == "Ubuntu"

- name: Add Docker GPG key
  apt_key:
    url: "https://download.docker.com/linux/{{ ansible_distribution | lower }}/gpg"
    state: present

- name: Add Docker repository
  apt_repository:
    repo: "deb [arch=amd64] https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} stable"
    state: present

- name: Install Docker and related packages
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin
    state: present

- name: Start Docker service
  service:
    name: docker
    state: started
    enabled: yes

- name: Add current user to docker group
  user:
    name: "{{ user_name }}"
    groups: docker
    append: yes
  notify: Restart Docker

```

![image](https://github.com/user-attachments/assets/9ca44f4c-f458-41f9-b387-ff511dfa7ef9)


## Deploy Frontend

```bash
---
# tasks file for roles/frontend

- name: Pull the latest image
  docker_image:
    name: "{{ frontend_image }}"
    source: pull

- name: Deploy frontend app on top docker
  docker_container:
    name: frontend
    image: "{{ frontend_image }}"
    state: started
    published_ports:
      - "{{ frontend_port }}:80"
    restart_policy: always  

- name: Run a test command
  shell: curl http://localhost:{{ frontend_port }}
  register: result

- name: Debug output
  debug:
    var: result.stdout
```

![image](https://github.com/user-attachments/assets/373c4c71-466f-4bd7-8b52-c33264fef1b1)

## Instalasi Monitoring Server

- Node Exporter
  Konfigurasi untuk instalasi node exporter

  ```bash
      - name: Ensure the user directory exists
      file:
        path: /home/{{ user_name }}/monitoring
        state: directory
        owner: "{{ user_name }}"
        group: "{{ user_name }}"
        mode: '0755'

    - name: Create Docker network 'monitoring' (ignore if already exists)
      command: docker network create monitoring
      ignore_errors: yes
      
    - name: Create docker-compose.yml for Node Exporter
      copy:
        content: |
          services:
            node-exporter:
                image: prom/node-exporter:latest
                container_name: node-exporter
                restart: unless-stopped
                volumes:
                    - /proc:/host/proc:ro
                    - /sys:/host/sys:ro
                    - /:/rootfs:ro
                command:
                    - '--path.procfs=/host/proc'
                    - '--path.rootfs=/rootfs'
                    - '--path.sysfs=/host/sys'
                    - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
                ports:
                    - "9100:9100"
                networks:
                    - monitoring
          networks:
            monitoring:
              external: true
              

        dest: /home/{{ user_name }}/monitoring/docker-compose.yml
        owner: "{{ user_name }}"
        group: "{{ user_name }}"
        mode: '0644'

    - name: Run Docker Compose to start Node Exporter
      shell: docker compose down && docker compose up -d
      args:
        chdir: /home/{{ user_name }}/monitoring
  ```


- Prometheus
  Konfigurasi untuk instalasi prometheus

  ```bash
  # tasks file for roles/prometheus
  
  - name: Create a test folder
    file:
      path: "/home/{{ user_name }}/test_folder"
      state: directory
      mode: '0755'
  
  - name: Create a directory if it does not exist
    file:
      path: /home/{{ user_name }}/monitoring/prometheus
      state: directory
      mode: '0755'
  
  - name: Create prometheus.yml for Prometheus
    copy:
      content: |
        global:
          scrape_interval: 30s

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ['localhost:9090']

        - job_name: 'node'
          static_configs:
            - targets: ["{{ node_domain4 }}"]

        - job_name: 'all-server'
          static_configs:
            - targets:
              - "{{ node_domain1 }}"
              - "{{ node_domain2 }}"
              - "{{ node_domain3 }}"
              - "{{ node_domain4 }}"

        - job_name: 'aws'
          static_configs:
            - targets:
              - "{{ node_domain1 }}"
              - "{{ node_domain2 }}"

        - job_name: 'biznet'
          static_configs:
            - targets:
              - "{{ node_domain3 }}"
              - "{{ node_domain4 }}"

        - job_name: 'cadvisor'
          scrape_interval: 15s
          static_configs:
            - targets:
              - "{{ server1 }}":"{{ cadvisor_port }}"
              - "{{ server2 }}":"{{ cadvisor_port }}"
              - "{{ server3 }}":"{{ cadvisor_port }}"
              - "{{ monitoring_server }}":"{{ cadvisor_port }}"


    dest: /home/{{ user_name }}/monitoring/prometheus/prometheus.yml
    owner: "{{ user_name }}"
    group: "{{ user_name }}"
    mode: '0644'

  - name: Create Docker network 'monitoring' (ignore if already exists)
    command: docker network create monitoring
    ignore_errors: yes
  
  - name: Create docker-compose.yml for Prometheus
    copy:
      content: |
        services:
          prometheus:
            image: prom/prometheus:latest
            container_name: prometheus
            user: "${UID}:${GID}"
            restart: unless-stopped
            volumes:
            - ./prometheus.yml:/etc/prometheus/prometheus.yml
            - ./prometheus_data:/prometheus
            command: 
              - --config.file=/etc/prometheus/prometheus.yml
              - --storage.tsdb.path=/prometheus
              - --web.console.libraries=/etc/prometheus/console_libraries
              - --web.console.templates=/etc/prometheus/consoles
              - --web.enable-lifecycle
            ports:
              - "9090:9090"
            networks:
              - monitoring
  
        networks:
          monitoring:
            external: true
  
        volumes:
          prometheus_data: {}
  
      dest: /home/{{ user_name }}/monitoring/prometheus/docker-compose.yml
      owner: "{{ user_name }}"
      group: "{{ user_name }}"
      mode: '0644'
  
  
  - name: Remove existing Prometheus container if it exists
    command: docker rm -f prometheus
    ignore_errors: yes
  
  - name: Run Docker Compose to start Prometheus
    shell: docker compose down prometheus && docker compose up -d
    args:
      chdir: /home/{{ user_name }}/monitoring/prometheus
    ```


- Grafana
  Konfigurasi untuk instalasi grafana
```bash
    - name: Ensure the user directory exists
      file:
        path: /home/{{ user_name }}/monitoring/grafana
        state: directory
        owner: "{{ user_name }}"
        group: "{{ user_name }}"
        mode: '0755'

    - name: Create Docker network 'monitoring' (ignore if already exists)
      command: docker network create monitoring
      ignore_errors: yes
      
    - name: Create docker-compose.yml for Grafana
      copy:
        content: |
          services:
            grafana:
              image: grafana/grafana
              container_name: grafana
              user: "${UID}:${GID}"
              restart: unless-stopped
              ports:
                - '3000:3000'
              environment:
                - GF_SERVER_ROOT_URL=http://{{ grafana_domain }}
              volumes:
                - ./grafana-storage:/var/lib/grafana
              networks:
                - monitoring
          networks:
            monitoring:
              external: true
              
          volumes:
            grafana-storage: {}

        dest: /home/{{ user_name }}/monitoring/grafana/docker-compose.yml
        owner: "{{ user_name }}"
        group: "{{ user_name }}"
        mode: '0644'

    - name: Remove existing grafana container if it exists
      command: docker rm -f grafana
      ignore_errors: yes

    - name: Run Docker Compose to start Grafana
      shell: docker compose down grafana && docker compose up -d
      args:
        chdir: /home/{{ user_name }}/monitoring/grafana
```

- cAdvisor
  Konfigurasi ansible untuk instalasi cAdvisor
  ```bash
  ---
  # tasks file for roles/cadvisor

    - name: Run cAdvisor container
      docker_container:
        name: cadvisor
        image: zcube/cadvisor:latest
        state: started
        volumes:
          - "/:/rootfs:ro"
          - "/var/run:/var/run:ro"
          - "/sys:/sys:ro"
          - "/var/lib/docker/:/var/lib/docker:ro"
          - "/dev/disk/:/dev/disk:ro"
        published_ports:
          - "8080:8080"
        detach: true
  ```

Contoh: Instalasi monitoring di monitoring server
![image](https://github.com/user-attachments/assets/1e7d369b-5207-4de2-b279-382bb5d05770)

## Setup Reverse Proxy
Konfigurasi ansible untuk reverse proxy 

```bash

    - name: Create directory for Nginx config
      file:
        path: /srv/nginx/conf.d
        state: directory
        mode: '0755'

    - name: Create directory for Nginx logs
      file:
        path: /srv/nginx/logs
        state: directory
        mode: '0755'

    - name: Create Nginx reverse proxy config
      template:
        src: reverse_proxy.conf.j2
        dest: /srv/nginx/conf.d/multi_domain_proxy.conf
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
```

## Konfigurasi certbot SSL dan update konfigurasi

Generate SSL Certbot dan Perbarui Konfigurasi Nginx Reverse Proxy

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

![image](https://github.com/user-attachments/assets/4a3eb834-2024-4d9e-91f3-ea5d0f8522da)

![image](https://github.com/user-attachments/assets/5261458a-a11c-48c3-80ff-1be58749a47b)

# Ansible Playbook

Ansible Playbook adalah file yang ditulis dalam format YAML yang berfungsi untuk mendefinisikan tasks yang akan dijalankan oleh Ansible pada satu atau beberapa host (server). Playbook memungkinkan kita untuk mengotomatisasi proses konfigurasi, deployment, dan manajemen sistem.

Setelah kita selesai membuat roles, maka kita dapat menjalankan ansible berdasarkan role yang sudah kita buat.

![image](https://github.com/user-attachments/assets/90346488-c75f-4fe5-a1bc-4e4ae811505b)

![image](https://github.com/user-attachments/assets/e0624fc4-78d3-4b8a-88db-ee80118b7c7e)

![image](https://github.com/user-attachments/assets/9a50d69d-1ca2-476b-92f0-f20432b7227e)

Disini kita juga bisa menambahkan tags untuk menandai satu atau lebih tasks di dalam sebuah playbook sehingga memungkinkan kita menjalankan hanya tugas-tugas tertentu tanpa harus mengeksekusi keseluruhan playbook. Ini sangat berguna ketika kita ingin menguji atau menjalankan bagian spesifik dari playbook, tanpa memproses semua tugas.

```
# Menjalankan ansible pada semua server
ansible-playbook playbooks/playbook.yml --tags "all-server" --ask-vault-password  

# Menjalankan ansible pada server monitoring
ansible-playbook playbooks/playbook.yml --tags "monitoring" --ask-vault-password

# Menjalankan ansible pada appserver/gateway
ansible-playbook playbooks/playbook.yml --tags "gateway" --ask-vault-password  
```

Contoh menjalankan ansible playbook untuk server monitoring saja dan hanya ingin instalasi docker dan create user

![image](https://github.com/user-attachments/assets/84919399-4afd-4fb1-9e6e-7f564c1d0445)

![image](https://github.com/user-attachments/assets/da23c243-ec95-4808-a80e-958b4921df45)

