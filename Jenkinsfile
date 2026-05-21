pipeline {
    agent any

    environment {
        // AWS Region
        REGION = "<AWS_REGION>"

        // ECR Repository
        ECR = "<AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/<APP_NAME>"

        // ECR Registry Endpoint
        ECR_REGISTRY = "<AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com"
    }

    stages {

        stage('Checkout Source Code') {
            steps {

                // Pull application code from GitHub using Jenkins SSH credentials
                git branch: 'main',
                    credentialsId: '<JENKINS_GITHUB_CREDENTIAL>',
                    url: 'git@github.com:<ORG_NAME>/<REPOSITORY>.git'

                script {
                    // Create a short Git commit ID for versioned image tagging
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    echo "Building image version: ${IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {

                // Build Docker image with both:
                // - Commit version tag
                // - latest tag

                sh """
                docker build \
                  -t ${ECR}:${IMAGE_TAG} \
                  -t ${ECR}:latest .
                """
            }
        }

        stage('Authenticate to Amazon ECR') {
            steps {

                // Login securely to ECR using IAM permissions

                sh '''
                aws ecr get-login-password --region ${REGION} | \
                docker login \
                  --username AWS \
                  --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {

                // Push both immutable and latest tags

                sh """
                docker push ${ECR}:${IMAGE_TAG}
                docker push ${ECR}:latest
                """
            }
        }

        stage('Deploy Application') {
            steps {

                sh """
                docker pull ${ECR}:${IMAGE_TAG}

                docker stop <CONTAINER_NAME> || true
                docker rm <CONTAINER_NAME> || true

                docker run -d \
                  --restart unless-stopped \
                  -p 80:5000 \
                  --name <CONTAINER_NAME> \
                  ${ECR}:${IMAGE_TAG}
                """
            }
        }
    }

    post {

        success {
            echo "Deployment successful → ${IMAGE_TAG}"
        }

        failure {
            echo "Deployment failed"
        }

        always {

            // Cleanup unused Docker images

            sh 'docker image prune -f || true'
        }
    }
}
