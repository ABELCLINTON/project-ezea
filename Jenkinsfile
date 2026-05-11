pipeline {
    agent any

    environment {
        IMAGE_NAME = "ezea-devops-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        TF_DIR     = "terraform"
        SSH_KEY    = credentials('ec2-ssh-key')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/ABELCLINTON/project-ezea.git'
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Test') {
            steps {
                sh """
                    docker run -d --name test-app -p 5001:5000 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    curl -f http://localhost:5001/health
                    docker stop test-app && docker rm test-app
                """
            }
        }

        stage('Deploy') {
            steps {
                dir("${TF_DIR}") {
                    sh "terraform init -input=false"
                    sh "terraform apply -auto-approve -var 'image_tag=${IMAGE_TAG}'"

                    script {
                        def EC2_IP = sh(script: 'terraform output -raw instance_public_ip', returnStdout: true).trim()

                        sh """
                            docker save ${IMAGE_NAME}:${IMAGE_TAG} -o /tmp/app.tar
                            scp -o StrictHostKeyChecking=no -i ${SSH_KEY} /tmp/app.tar ec2-user@${EC2_IP}:/home/ec2-user/
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ec2-user@${EC2_IP} '
                                docker load -i /home/ec2-user/app.tar
                                docker stop ezea-app || true && docker rm ezea-app || true
                                docker run -d --name ezea-app --restart always -p 5000:5000 ${IMAGE_NAME}:${IMAGE_TAG}
                            '
                            rm -f /tmp/app.tar
                        """

                        echo "✅ Live at: http://${EC2_IP}:5000"
                    }
                }
            }
        }
    }

    post {
        failure {
            sh 'docker stop test-app || true && docker rm test-app || true'
            echo '❌ Pipeline failed. Check logs above.'
        }
    }
}
