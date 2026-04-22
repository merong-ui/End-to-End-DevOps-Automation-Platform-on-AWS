pipeline {
    agent any  // Run pipeline on any available Jenkins agent

    environment {
        REGION = "us-east-1"  

        // Full ECR repo (used for tagging + pushing)
        ECR = "217428065218.dkr.ecr.us-east-1.amazonaws.com/myapp"

        // ECR registry only (used for login)
        ECR_REGISTRY = "217428065218.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {

        stage('Checkout Code') {
            steps {
                //Pull code from GitHub repository using SSH-based authentication (no tokens or passwords)
                git branch: 'main',
                    credentialsId: 'github-ssh',
                    url: 'git@github.com:merong-ui/End-to-End-DevOps-Automation-Platform-on-AWS.git'
             }
        }

        stage('Build Docker Image') {
            steps {
                // Build and tag image directly for ECR
                sh "docker build -t $ECR:latest ."
            }
        }

        stage('Login to ECR') {
            steps {
                // Authenticate Docker to AWS ECR using IAM role (secure, no stored credentials)
                sh '''
                aws ecr get-login-password --region $REGION | \
                docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                // Push image to ECR repository
                sh "docker push $ECR:latest"
            }
        }

        stage('Deploy to EC2') {
            steps {
                // Replace old container with new version
                sh '''
                docker stop myapp || true
                docker rm myapp || true
                docker run -d -p 80:5000 --name myapp $ECR:latest
                '''
            }
        }
    }
}
