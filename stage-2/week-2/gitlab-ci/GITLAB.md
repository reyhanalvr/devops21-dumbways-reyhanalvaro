```
Repository && Reference:
Runner
wget spider

Tasks :
[ Jenkins ]

Implementasikan penggunaan Gitlab Runner pada aplikasi Frontend Kalian
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

# 1. Buat akun gitlab 

![image](https://github.com/user-attachments/assets/51312f61-73ad-4711-a6f6-a3e8eda44df7)

# 2. Push SCM dari local-server ke gitlab

![image](https://github.com/user-attachments/assets/7db4d476-e9a5-4871-beba-73b34245ad3d)

# 3. Buatlah Job menggunakan gitlab-ci untuk aplikasi Frontend

```bash
variables:
  IMAGE : team2/literature/frontend
  TAG : test
  SSH_USER: team2-fe
  SSH_HOST: 35.198.212.132
  DIR : /home/team2-fe/apps/literature-frontend
  PORT: 3010
  CONTAINER_NAME : fe-production
  DOCKER_USERNAME: reyhanalvr
  DOCKER_PASSWORD: $DOCKER_PASSWORD
  DOCKER_REGISTRY: reyhanalvr/team2-literature-frontend

# Define the available stages
stages:
  - pull
  - build
  - test
  - push
  - deploy

.setup_ssh: &setup_ssh
  before_script:
    - 'command -v ssh-agent >/dev/null || ( apk add --update openssh )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts

# Pull the latest code from Git
pull:
  stage: pull
  image: docker
  <<: *setup_ssh
  script:
    - echo "Pulling latest code from Git"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && git pull origin production"
  after_script:
    - echo "Git pull success"

# Docker Build Stage
build:
  stage: build
  image: docker
  <<: *setup_ssh
  script:
    - echo "Building Docker image"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker build -t $IMAGE:$TAG ."
  after_script:
    - echo "Docker build success"

# Docker Test Stage
test:
  stage: test
  image: docker
  <<: *setup_ssh
  script:
    - echo "Running Docker container"
    - ssh $SSH_USER@$SSH_HOST "docker run -it -p $PORT:3000 -d --name $CONTAINER_NAME $IMAGE:production"
    - echo "Testing if the website is up"
    - ssh $SSH_USER@$SSH_HOST "if wget -q --spider http://localhost:$PORT; then echo 'Website up'; else echo 'Website down'; fi"
  after_script:
    - echo "Docker run and test success"

push:
   stage: push
   image: docker
   services:
     - docker:dind
   script:
  - ssh $SSH_USER@$SSH_HOST "cd $DIR"
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker push $DOCKER_REGISTRY:$TAG"
  - ssh $SSH_USER@$SSH_HOST "exit"
  - echo "Push Image to Docker Hub Successfully!"


# Deployment Stage
deploy:
  stage: deploy
  image: docker
  <<: *setup_ssh
  script:
    - echo "Deploying application"
    - ssh $SSH_USER@$SSH_HOST "docker compose -f $COMPOSE down" 
    - ssh $SSH_USER@$SSH_HOST "docker compose -f $COMPOSE up -d"
  after_script:
    - echo "Deploy success"
```

### Setiap ada perubahan code maka akan langsung ke auto trigger kalau di gitlab CI/CD dan langsung akan menjalankan pipeline

![image](https://github.com/user-attachments/assets/61f8bbea-1dd8-4d93-a691-384f9143c637)

### Gitlab-CI Discord Notification

![image](https://github.com/user-attachments/assets/01aabb8e-43f4-4b59-824b-1cf956064603)


