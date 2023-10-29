pipeline {
   agent {
        label 'jenkins-jenkins-agent'
    }


    environment {
        DOCKERHUB_REPO = 'simplewebapp'
        IMAGE_TAG = 'latest'
        REMOTE_HOST = '44.199.183.25'
        CONTAINER_NAME = 'simplewebapp_container'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'DOCKERHUB_USERNAME:DOCKERHUB_PASS') {
                            def dockerImage = docker.image("${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${IMAGE_TAG}")
                            dockerImage.push()
                        }
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sshagent(credentials: ['gitlab_key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $REMOTE_HOST "
                            docker pull ${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${IMAGE_TAG}
                            docker stop $CONTAINER_NAME || true
                            docker rm $CONTAINER_NAME || true
                            docker run --name $CONTAINER_NAME -d -p 8080:80 ${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${IMAGE_TAG}

                        "
                    """
                }
            }
        }
    }
}

