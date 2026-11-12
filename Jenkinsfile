pipeline {
    agent any

    environment {
        AWS_REGION   = 'ap-south-1'
        // TODO: replace <account-id> with your 12-digit AWS account ID
        ECR_REGISTRY = '<account-id>.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPO     = 'ts-devops-demo'
        IMAGE_TAG    = "build-${BUILD_NUMBER}"
        // TODO: replace <app-private-ip> with the app_private_ip Terraform output
        APP_HOST     = '<app-private-ip>'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn -B clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                    docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['app-server-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@$APP_HOST "
                            set -e
                            aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin $ECR_REGISTRY
                            sudo docker pull $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                            sudo docker rm -f ts-app || true
                            sudo docker run -d --name ts-app --restart unless-stopped -p 80:8080 -e APP_VERSION=$IMAGE_TAG $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
                        "
                    '''
                }
            }
        }

        stage('Verify') {
            steps {
                sh 'sleep 20'
                sh 'curl -f http://$APP_HOST'
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f'
        }
    }
}
