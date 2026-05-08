# Architecture Diagram

## Infrastructure Overview

![Architecture](https://i.imgur.com/placeholder.png)

## Component Breakdown

### Network Layer
- VPC: 10.0.0.0/16
- Public Subnet: 10.0.1.0/24
- Internet Gateway for public access

### Compute Layer
- EC2 t3.small (Amazon Linux 2)
- Docker containerized Flask app
- Jenkins CI/CD server

### Monitoring Layer
- CloudWatch Agent
- Custom metrics namespace: SampsonDevOps/EC2
- Log groups for Jenkins and system logs