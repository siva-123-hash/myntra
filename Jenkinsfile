pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'your-dockerhub-username'
        DOCKERHUB_REPO = 'myntra-app'
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: ''
                sh 'pwd && ls -l'
            }
        }

        stage('Build Maven Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG .
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG
                    docker logout
                    """
                }
            }
        }

        stage('Deploy to Swarm') {
            steps {
                script {
                    sh """
                    docker service update --image $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG myntra_service || \
                    docker service create --name myntra_service -p 8080:8080 $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG
                    """
                }
            }
        }
    }
}
