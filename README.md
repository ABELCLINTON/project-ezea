# 🚀 DevOps Engineer Practical Challenge
## Production-Ready Application Deployment

---

## 📋 Table of Contents
- [Architecture Overview](#architecture-overview)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Deployment Steps](#deployment-steps)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Logging](#monitoring--logging)
- [Design Decisions](#design-decisions)
- [Assumptions](#assumptions)
- [Limitations & Improvements](#limitations--improvements)

---

## 🏗️ Architecture Overview

This project deploys a containerized Python Flask web application
on AWS EC2 using a fully automated DevOps pipeline.

┌─────────────────────────────────────────────────┐
│                   GitHub Repo                   │
│         (Source Code + Jenkinsfile)             │
└─────────────────┬───────────────────────────────┘
│ triggers
▼
┌─────────────────────────────────────────────────┐
│              Jenkins CI/CD Pipeline             │
│   Build → Test → Deploy → Verify                │
└─────────────────┬───────────────────────────────┘
│ deploys to
▼
┌─────────────────────────────────────────────────┐
│                  AWS (us-east-1)                │
│                                                 │
│   VPC (10.0.0.0/16)                             │
│   └── Public Subnet (10.0.1.0/24)               │
│       └── EC2 t3.small                          │
│           ├── Docker Container (Flask App :5000)│
│           ├── Jenkins Server (:8080)            │
│           └── CloudWatch Agent                  │
│                                                 │
│   Security Group                                │
│   ├── Port 22   (SSH)                           │
│   ├── Port 5000 (Flask App)                     │
│   └── Port 8080 (Jenkins)                       │
└─────────────────────────────────────────────────┘
│ monitored by
▼
┌─────────────────────────────────────────────────┐
│             AWS CloudWatch                      │
│   CPU, Memory, Disk Metrics + App Logs          │
└─────────────────────────────────────────────────┘

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Application | Python Flask |
| Containerization | Docker |
| Infrastructure as Code | Terraform |
| CI/CD Pipeline | Jenkins |
| Cloud Provider | AWS (EC2, VPC, CloudWatch) |
| Version Control | GitHub |
| Monitoring | AWS CloudWatch |

---

## ✅ Prerequisites

Before deploying, make sure you have:

- AWS Account with IAM user and Access Keys configured
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (v1.0+)
- Docker Desktop installed
- Git installed
- SSH key pair generated (`~/.ssh/id_rsa`)

---

## 🚀 Deployment Steps

### 1. Clone the Repository
```bash
git clone https://github.com/ABELCLINTON/project-ezea.git
cd project-ezea
```

### 2. Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```
Note the output values — you'll need the EC2 public IP.

### 3. Access Jenkins
- Open browser: `http://<EC2_PUBLIC_IP>:8080`
- Unlock Jenkins using:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 4. Configure Jenkins Pipeline
- Create a new Pipeline job
- Point it to this GitHub repository
- Use the Jenkinsfile in the root directory
- Click Build Now

### 5. Access the Application
Once the pipeline runs successfully:
- App: `http://<EC2_PUBLIC_IP>:5000`
- Health Check: `http://<EC2_PUBLIC_IP>:5000/health`

---

## 🔄 CI/CD Pipeline

The Jenkins pipeline consists of 5 automated stages: