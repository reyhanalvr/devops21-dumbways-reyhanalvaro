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
  TAG : latest
  SSH_USER: team2-fe
  SSH_HOST: 34.143.209.44
  DIR : /home/team2-fe/apps/literature-frontend
  PORT: 3010
  CONTAINER_NAME : fe-production
  DOCKER_USERNAME: reyhanalvr
  DOCKER_PASSWORD: $DOCKER_PASSWORD
  DOCKER_REGISTRY: reyhanalvr/team2-literature-frontend
  COMPOSE: docker-compose.yml
  DISCORD_WEBHOOK: "https://discord.com/api/webhooks/1288737919577886743/C--62xLZbiYwpUdejmN8AL7PHxjNnp-X6ba4ThljF_sFji4qTWOMbomSHHrT-MOrC21s"


stages:
  - pull
  - build
  - test
  - push
  - deploy
  - notify-failure
  - notify-success

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
    - echo "Pulling the latest code from Git"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && git checkout production && git pull origin production"
  after_script:
    - echo "Git pull successful"

# Docker Build Stage
build:
  stage: build
  image: docker
  <<: *setup_ssh
  script:
    - echo "Building Docker image"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker build -t $IMAGE:$TAG ."
  after_script:
    - echo "Docker build successful"

# Docker Test Stage
test:
  stage: test
  image: docker
  <<: *setup_ssh
  script:
  - echo "Delete running container"
  - ssh $SSH_USER@$SSH_HOST "docker rm -f $CONTAINER_NAME"
  - echo "Running Docker container for testing"
  - ssh $SSH_USER@$SSH_HOST "docker run --rm -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE:$TAG && wget -q --spider http://localhost:$PORT && echo 'Website  is up' || echo 'Website is down'"
  after_script:
    - echo "Docker run and test completed successfully"


# Docker Push Stage
push:
  stage: push
  image: docker
  <<: *setup_ssh
  script:
    - echo "Tagging Docker image on remote server"
    - ssh $SSH_USER@$SSH_HOST "docker tag $IMAGE:$TAG reyhanalvr/team2-literature-frontend:production"
    - echo "Pushing Docker image to Docker Hub from remote server"
    - ssh $SSH_USER@$SSH_HOST "docker push reyhanalvr/team2-literature-frontend:production"
  after_script:
    - echo "Docker image pushed to Docker Hub successfully"

# Deployment Stage
deploy:
  stage: deploy
  image: docker
  <<: *setup_ssh
  script:
    - echo "Deploying application"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker-compose -f $COMPOSE down"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker compose pull"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker-compose -f $COMPOSE up -d"
  after_script:
    - echo "Deployment successful"

notify-success:
    stage: notify-success
    when: on_success
    script:
        - wget https://raw.githubusercontent.com/NurdTurd/gitlab-ci-discord-webhook/master/send.sh
        - bash ./send.sh success $DISCORD_WEBHOOK
notify-failure:
    stage: notify-failure
    when: on_failure
    script:
        - wget https://raw.githubusercontent.com/NurdTurd/gitlab-ci-discord-webhook/master/send.sh
        - bash ./send.sh failure $DISCORD_WEBHOOK
```

### Setiap ada perubahan code maka akan langsung ke auto trigger kalau di gitlab CI/CD dan langsung akan menjalankan pipeline

![image](https://github.com/user-attachments/assets/61f8bbea-1dd8-4d93-a691-384f9143c637)

### Gitlab-CI Discord Notification

![image](https://github.com/user-attachments/assets/01aabb8e-43f4-4b59-824b-1cf956064603)


