```Repository && Reference:
Cloudflare
Jenkins Installation
Jenkins Reverse proxy
wget spider

Tasks :
[ Jenkins ]

Installasi Jenkins on top Docker or native
Setup SSH-KEY di local server jenkins kalian, agar dapat login ke dalam server menggunakan SSH-KEY
Reverse Proxy Jenkins
gunakan domain ex. jenkins.team1.studentdumbways.my.id
reverse proxy sesuaikan dengan ketentuan yang ada di dalam Jenkins documentation
Buatlah beberapa Job untuk aplikasi kalian yang telah kalian deploy di task sebelumnya (staging && production)
Untuk script CICD atur flow pengupdate an aplikasi se freestyle kalian dan harus mencangkup
Pull dari repository
Dockerize/Build aplikasi kita
Test application
Push ke Docker Hub
Deploy aplikasi on top Docker
Auto trigger setiap ada perubahan di SCM
Buat job notification ke discord
```


# Installasi Jenkins via Docker

Banyak cara untuk installasi jenkins, cara yg umum seperti native bisa dilakukan tetapi kita wajib melalkukan installasi java (JDK, JRE) karena jenkins di bangun menggunakan java jadi butuh runtime tersebut. di contoh ini saya installasi jenkins nya secara native.

### CARA INSTALASI

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

```bash
sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
```


```
# You can enable the Jenkins service to start at boot with the command:
sudo systemctl enable jenkins

# You can start the Jenkins service with the command:
sudo systemctl start jenkins

# You can check the status of the Jenkins service using the command:
sudo systemctl status jenkins
```

Setelah instalasi selesai kita buka http://localhost:8080

![image](https://github.com/user-attachments/assets/362273f3-e88d-427d-abb0-fbd68155dad0)

Masukkan password dari console dengan mengakses file /var/jenkins_home/secrets/initialAdminPassword 

![image](https://github.com/user-attachments/assets/02abf822-3594-4c14-b24c-5f224bee9517)

Reverse Proxy dan Install SSL Untuk Jenkins 

```
upstream jenkins {
  keepalive 32; # keepalive connections
  server 127.0.0.1:8080; # jenkins ip and port
}

# Required for Jenkins websocket agents
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen          80;       # Listen on port 80 for IPv4 requests
  listen 443 ssl;
  server_name     jenkins.team2.studentdumbways.my.id;  # replace 'jenkins.example.com' with your server domain name
  ssl_certificate /etc/letsencrypt/live/pipeline-team2.studentdumbways.my.id/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/pipeline-team2.studentdumbways.my.id/privkey.pem;


  # this is the jenkins web root directory
  # (mentioned in the output of "systemctl cat jenkins")
  root            /var/run/jenkins/war/;

  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location ~ "^/static/[0-9a-fA-F]{8}\/(.*)$" {
    # rewrite all static files into requests to the root
    # E.g /static/12345678/css/something.css will become /css/something.css
    rewrite "^/static/[0-9a-fA-F]{8}\/(.*)" /$1 last;
  }

  location /userContent {
    # have nginx handle all the static requests to userContent folder
    # note : This is the $JENKINS_HOME dir
    root /var/lib/jenkins/;
    if (!-f $request_filename){
      # this file does not exist, might be a directory or a /**view** url
      rewrite (.*) /$1 last;
      break;
    }
    sendfile on;
  }

  location / {
      sendfile off;
      proxy_pass         http://jenkins;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $http_host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_request_buffering    off; # Required for HTTP CLI commands
  }

}

```

![image](https://github.com/user-attachments/assets/37199314-870d-4546-a747-489640c77c7b)

## Install plugins ssh-agent dan plugins lain yang kalian butuhkan

![image](https://github.com/user-attachments/assets/54f59e3e-7788-45b3-a82a-0ff028e78420)

## Setup SSH-KEY di jenkins kalian, agar dapat login ke dalam server menggunakan SSH-KEY

![image](https://github.com/user-attachments/assets/626bd546-858e-4855-b019-441c7682fd67)

Masukkan kunci publik ke authorized_keys

![image](https://github.com/user-attachments/assets/4c592bae-3164-4a07-8baa-42a776ede7ac)

Simpan private keynya di jenkins credential

![image](https://github.com/user-attachments/assets/181ea1ec-cce3-449e-b9fb-67bac66bd4b2)


### Job CI/CD aplikasi wayshub backend menggunakan Jenkins

untuk membuat job kita wajib push repository ke github lalu kita masukan ke bagian jenkins job, pilih yang pipeline

![image](https://github.com/user-attachments/assets/2caad62e-90b8-4134-ae8f-017de224d886)

Code Pipeline 

```jenkinsfile
@Library('jenkins-shared-library') _

pipeline {
    agent any
    
    environment {
        REMOTE_SERVER = "${REMOTE_SERVER_STAGING}"
        SSH_USER = "${REMOTE_USERNAME_STAGING}"
        REPO_DIR = "${REPO_DIR_STAGING}" 
        SSH_CREDENTIALS = "${SSH_CREDENTIALS}"
        DOCKER_IMAGE = "${DOCKER_IMAGE_STAGING}"
        PORT = "${BACKEND_STAGING_PORT}"
        APP_URL = "${BACKEND_STAGING_URL}"
        CONTAINER_NAME = "${CONTAINER_BE_STAGING}"
        DOCKERHUB_CREDENTIALS = "${DOCKERHUB_CREDENTIALS}"
        DOCKERHUB_REPO = "${DOCKERHUB_BE_REPO}"
        DISCORD_WEBHOOK_URL = "${DISCORD_WEBHOOK_URL}"
        BRANCH = "staging"
    }

    stages {
        stage('Pull Repository') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        try {
                            echo "DISCORD_WEBHOOK_URL: ${DISCORD_WEBHOOK_URL}"
                            sh """
                            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                            cd ${REPO_DIR} 
                            git pull origin ${BRANCH} // Menggunakan variabel branch
                            echo "Git Pull Telah Berhasil"
                            exit
                            EOF
                            """
                            sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Git Pull Berhasil dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                        } catch (Exception e) {
                            sendDiscordNotification("❌ *Staging Deployment Failed* ❌", "Git Pull Gagal: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                            error("Git Pull failed.")
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        try {
                            sh """
                            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                            cd ${REPO_DIR} 
                            docker build -t ${DOCKER_IMAGE} .
                            echo "Docker Image Build Berhasil"
                            exit
                            EOF
                            """
                            sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Build Docker Image Berhasil dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                        } catch (Exception e) {
                            sendDiscordNotification("❌ *Docker Build Failed* ❌", "Docker Build Gagal: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                            error("Docker Build failed.")
                        }
                    }
                }
            }
        }

        stage('Run Test Application') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        try {
                            sh """
                            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                            echo "Menghapus container ${CONTAINER_NAME}"
                            docker rm -f ${CONTAINER_NAME}

                            sleep 2

                            echo "Menjalankan container ${CONTAINER_NAME}"
                            docker run -d -p ${PORT}:5000 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
                            echo "Backend running"
                            exit
                            EOF
                            """
                            sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Run Application berhasil dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                        } catch (Exception e) {
                            sendDiscordNotification("❌ *Run Test Application Failed* ❌", "Gagal menjalankan aplikasi: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                            error("Run Test Application failed.")
                        }
                    }
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        try {
                            sh """
                            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                            sleep 3
                            if wget --spider --server-response ${APP_URL} 2>&1 | grep -q "404 Not Found"; then
                                echo "Backend berjalan"
                            else 
                                echo "Backend tidak berjalan"
                                exit 1
                            fi
                            exit
                            EOF
                            """
                            sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Test Aplikasi - Aplikasi Berjalan Dengan Baik dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                        } catch (Exception e) {
                            sendDiscordNotification("❌ *Test Application Failed* ❌", "Uji aplikasi gagal: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                            error("Test Application failed.")
                        }
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                            try {
                                sh """
                                ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                                echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
                                docker tag ${DOCKER_IMAGE} ${DOCKERHUB_REPO}:${BRANCH} // Menggunakan variabel branch

                                echo "Melakukan push ke Dockerhub"
                                docker push ${DOCKERHUB_REPO}:${BRANCH}

                                echo "Docker image berhasil di push ke repository"
                                exit
                                EOF
                                """
                                sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Push Docker Image ke Registry Berhasil dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                            } catch (Exception e) {
                                sendDiscordNotification("❌ *Push Docker Image Failed* ❌", "Push Docker Image Gagal: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                                error("Push Docker Image failed.")
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy App on Top Docker') {
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        try {
                            sh """
                            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${REMOTE_SERVER} << EOF
                            cd ${REPO_DIR}
                            
                            echo "Deploy aplikasi on top docker"
                            docker compose down
                            docker compose up -d

                            echo "Aplikasi telah berjalan"
                            exit
                            EOF
                            """
                            sendDiscordNotification("🚧 *Staging Deployment Notification* 🚧", "Deploy Aplikasi on top docker berhasil dari branch ${BRANCH}.", "success", DISCORD_WEBHOOK_URL)
                        } catch (Exception e) {
                            sendDiscordNotification("❌ *Deployment Failed* ❌", "Deploy aplikasi gagal: ${e.message}", "error", DISCORD_WEBHOOK_URL)
                            error("Deploy App failed.")
                        }
                    }
                }
            }
        }
    }
}

```

### Auto trigger setiap ada perubahan di SCM

untuk membuat auto trigger kita wajib menambahkan url jenkins ke github repository kita di menu webhooks

![image](https://github.com/user-attachments/assets/1e3343f5-7a1d-44a9-9fde-235d53e715bc)

### Discord Job Notification

![image](https://github.com/user-attachments/assets/d03bbf87-0acf-479c-a0bb-361102af6382)
