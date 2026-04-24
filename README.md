
# End-to-End DevOps Automation Platform on AWS 

Automated AWS DevOps Platform: Integrating IaC, Containerized CI/CD, and Observability

**Architecture Overview**

<img width="726" height="424" alt="arti" src="https://github.com/user-attachments/assets/83af3bce-35cc-4ddd-8166-2bc775e2d6e2" />





## Project Overview
End-to-end DevOps automation platform on AWS that automates application deployment using CI/CD, Infrastructure as Code, and containerization. It integrates GitHub, Jenkins, Docker, and AWS services to build, deploy, and monitor a Python Flask application.

Terraform provisions scalable infrastructure, while Jenkins automates the pipeline to build, push, and deploy Docker images to EC2 via Amazon ECR. The system also includes monitoring with CloudWatch, EventBridge, Lambda, and SNS, along with EC2 scheduling for cost optimization.

## Core Technology Stack
- **Infrastructure**: Terraform (AWS Provider)
- **CI/CD**: Jenkins (Dockerized with Socket Mounting)
- **Containerization**: Docker & Amazon ECR
- **Cloud Services**: EC2, IAM, CloudWatch, EventBridge, Lambda, SNS
- **App Stack**: Python Flask

## System Architecture
The system follows a modular CI/CD workflow:

  1. Developer pushes code to GitHub.
  2. GitHub Webhook triggers Jenkins pipeline
  3. Jenkins (running in Docker on EC2) pulls code and builds Docker image
  4. Docker image is pushed to Amazon ECR
  5. EC2 pulls latest image and deploys the updated container
  6. CloudWatch collects logs and metrics
  7. EventBridge detects system events and triggers Lambda
  8. Lambda sends alerts through SNS (email notifications)
    

## Phase 1: Infrastructure as Code (Terraform)
The foundation is built to be 100% reproducible. I used Terraform to eliminate "Configuration Drift."

- Provisioned AWS infrastructure using Terraform
- Created custom VPC with public subnets and routing configuration
- Attached Elastic IP to ensure consistent Jenkins endpoint
- Configured Security Groups using least privilege principles (ports: 22, 80, 8080, 5000)

## Phase 2: Application & Containerization

**Flask App**

A lightweight Python Flask app used to validate CI/CD pipeline functionality.

**Dockerfile**

Optimized for a small footprint and security.

- Built using python:3.9-slim base image
- Optimized for lightweight deployment
- Exposes application on port 5000

## Phase 3: CI/CD Pipeline (Jenkins)

- Jenkins runs in a Docker container on EC2
- Uses Docker socket mounting to build and manage containers on the host
- Fully automated pipeline using Jenkinsfile (Declarative Pipeline)
- GitHub Webhook enables continuous integration without manual triggers

**Security**
- IAM Instance Profile used for secure ECR access
- No hardcoded AWS credentials

## Phase 4: Reliability & Cost Optimization

**Real-Time Monitoring (SRE Approach)**

Instead of traditional polling, I implemented Event-Driven Monitoring:
- **CloudWatch** monitors logs and system metrics
- **EventBridge** detects instance state-changes (e.g., stopped or failure).
- **Lambda** processes the event and publishes a critical alert to an SNS Topic.
- **Result**: The DevOps team receives an email notification within seconds of a failure.

**Automated Cost Efficiency**

To adhere to the AWS Well-Architected Framework (Cost Optimization pillar):
- Automated EC2 start/stop using EventBridge schedules
- Cron Job: Automatically toggles the EC2 instance (Stop at 6 PM / Start at 9 AM).
- Business Impact: Reduces compute usage during non-business hours.
  
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





