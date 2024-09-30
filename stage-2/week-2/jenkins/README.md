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

