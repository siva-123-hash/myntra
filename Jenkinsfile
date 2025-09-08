pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "anithavalluri/myntra"   // change to your DockerHub repo
        IMAGE_TAG = "v1"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/anithavalluri02/myntra.git'
                sh 'ls -l'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  echo "Building Docker image..."
                  docker build -t $DOCKERHUB_REPO:$IMAGE_TAG .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                      echo "Logging into DockerHub..."
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                      docker push $DOCKERHUB_REPO:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                  echo "Running Myntra container locally..."

                  # stop old container if running
                  docker rm -f myntra-container || true

                  # run new container on port 8080
                  docker run -d --name myntra-container -p 8080:80 $DOCKERHUB_REPO:$IMAGE_TAG

                  echo "Myntra container is up at http://<server-ip>:8080"
                '''
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                sh '''
                  echo "Deploying Myntra app on Swarm..."

                  # initialize swarm if not already
                  docker swarm init || true

                  # remove old service if exists
                  docker service rm myntra || true

                  # create new service with exposed port 8080
                  docker service create \
                    --name myntra \
                    --publish 8080:80 \
                    $DOCKERHUB_REPO:$IMAGE_TAG

                  echo "Myntra service deployed successfully!"
                '''
            }
        }
    }
}
