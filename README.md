
# End-to-End DevOps Automation Platform on AWS 

Automated AWS DevOps Platform: Integrating IaC, Containerized CI/CD, and Observability

**Architecture Overview**

<img width="726" height="424" alt="arti" src="https://github.com/user-attachments/assets/83af3bce-35cc-4ddd-8166-2bc775e2d6e2" />





## Project Overview
This project demonstrates a production-ready DevOps ecosystem that bridges the gap between development and operations. It moves beyond simple scripts to Monitoring-enabled, cost-optimized, and secure pipeline using Infrastructure and Pipeline as Code.

## Core Technology Stack
- **Infrastructure**: Terraform (AWS Provider)
- **CI/CD**: Jenkins (Dockerized with Socket Mounting)
- **Containerization**: Docker & Amazon ECR
- **Operations**: CloudWatch, AWS Lambda, Amazon SNS, EventBridge
- **App Stack**: Python Flask

## System Architecture
The platform follows a Modular DevOps architecture ensuring that each component handles a specific part of the lifecycle:

  1. Developer pushes code to GitHub.

  2. GitHub Webhook triggers a Jenkins build immediately.

  3. Jenkins (running in Docker) builds a new image via the host's Docker socket.

  4. The image is versioned and pushed to Amazon ECR using IAM Role authentication.

  5. The updated container is deployed to the EC2 production environment.

  6. CloudWatch collects metrics and logs, while EventBridge listens for events (such as instance state changes) and routes them to Lambda, which triggers SNS alerts.
    

## Phase 1: Infrastructure as Code (Terraform)
The foundation is built to be 100% reproducible. I used Terraform to eliminate "Configuration Drift."

- **Networking**: Custom VPC with Public Subnets and specialized Route Tables.
- **Persistence**: Attached an Elastic IP to the host to ensure the Jenkins URL remains static across instance restarts.
- **Security**: Implemented a Security Group firewall following the Principle of Least Privilege, exposing only ports 22, 80, 8080, and 5000.

## Application & Containerization

** Flask App**

 A lightweight Python application used to validate the deployment pipeline.

 Python

    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def home():
        return "DevOps App Running Successfully!"

    if __name__ == "__main__":
        app.run(host='0.0.0.0', port=5000)
        
  **Dockerfile**

  Optimized for a small footprint and security.

    FROM python:3.9-slim
    WORKDIR /app
    COPY . .
    RUN pip install -r requirements.txt
    EXPOSE 5000
    CMD ["python", "app.py"]
    

## Phase 2: Secure CI/CD Pipeline (Jenkins)

The pipeline is defined as a Declarative Jenkinsfile, ensuring the build logic is version-controlled.

**Jenkins Setup**:

Jenkins runs inside a Docker container on an EC2 instance and uses the host’s Docker engine to build and deploy application containers on the same machine.

**Key Technical Differentiators:**

- **Docker-outside-of-Docker**: Mounted /var/run/docker.sock to the Jenkins container, allowing it to manage the host’s Docker daemon without the overhead of nested virtualization.
- **Identity-Based Security**: Used IAM Instance Profiles. Jenkins assumes a role to push to ECR, meaning zero AWS Access Keys are stored on the server.
- **Webhooks**: Achieved true Continuous Integration by removing the need for manual build triggers.


## Phase 3: Reliability & Cost Optimization
**Real-Time Monitoring (SRE Approach)**

Instead of traditional polling, I implemented Event-Driven Monitoring:
- **EventBridge** detects instance state-changes (e.g., stopped or failure).
- **Lambda** processes the event and publishes a critical alert to an SNS Topic.
- **Result**: The DevOps team receives an email notification within seconds of a failure.

**Automated Cost Efficiency**

To adhere to the AWS Well-Architected Framework (Cost Optimization pillar):
- Created a serverless "Light Switch" using EventBridge Schedules.
- Cron Job: Automatically toggles the EC2 instance (Stop at 6 PM / Start at 9 AM).
- Business Impact: Reduces monthly infrastructure burn-rate by approximately 60%.
  
## Proof of Work (Screenshots)

**Application:-**       
**browser is showing the app output**

<img width="452" height="134" alt="Screenshot 2026-04-22 054331" src="https://github.com/user-attachments/assets/5f992867-6a77-42f1-a397-672d62ea4c14" />


**Jenkins Pipeline:-**

**Jenkins build stages (Success Green**) 

<img width="1895" height="336" alt="Screenshot 2026-04-22 164047" src="https://github.com/user-attachments/assets/c6e7b9f0-6eb2-403f-a92a-5b0b15e67787" />



**ECR Image:-**

<img width="543" height="246" alt="Screenshot 2026-04-22 164157" src="https://github.com/user-attachments/assets/9726e780-adda-4637-98c5-bd331d5a85c3" />


**SNS Alerts:-**
**Successfull creation**

<img width="1740" height="350" alt="Screenshot 2026-04-22 172110" src="https://github.com/user-attachments/assets/59d3c49d-7f1c-4396-aef1-5c095cefdf34" />


**Email Notification:-**

<img width="1200" height="268" alt="Screenshot 2026-04-23 191340" src="https://github.com/user-attachments/assets/869b7b2f-07a8-4203-ae1f-ab23155e574d" />


**Webhook Logic:-**  

**Webhook Success**

<img width="673" height="408" alt="Screenshot 2026-04-22 170108" src="https://github.com/user-attachments/assets/4fa9e3bb-13ce-4fa3-9515-d447812c605b" />




Schedule 

<img width="1001" height="469" alt="Screenshot 2026-04-22 190749" src="https://github.com/user-attachments/assets/07521b13-1686-41ea-8b08-d1e3e6164c6b" />





