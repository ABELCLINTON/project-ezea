pipeline {
    agent any

    environment {
        APP_IMAGE = "sampson-devops-app"
        CONTAINER_NAME = "sampson-app"
        APP_PORT = "5000"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${APP_IMAGE}:${BUILD_NUMBER} ."
                sh "docker tag ${APP_IMAGE}:${BUILD_NUMBER} ${APP_IMAGE}:latest"
            }
        }

        stage('Test') {
            steps {
                echo 'Running basic health test...'
                sh """
                docker stop test-container || true
                docker rm test-container || true
                docker run -d --name test-container -p 5001:5000 sampson-devops-app:latest
                sleep 5
                docker exec test-container python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1
                docker stop test-container
                docker rm test-container
            """
            }
    }
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh """
                    # Stop and remove existing container if running
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true

                    # Run the new container
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:5000 \
                        --restart always \
                        ${APP_IMAGE}:latest
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sh """
                sleep 5
                docker exec sampson-app python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"
                echo 'Application is running successfully!'
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully! App is live!'
        }
        failure {
            echo 'Pipeline failed. Check the logs above.'
        }
        always {
            echo 'Cleaning up old Docker images...'
            sh "docker image prune -f || true"
        }
    }
}