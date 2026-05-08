#!/bin/bash
yum update -y

# Install Docker
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Java (required for Jenkins)
yum install java-17-amazon-corretto -y

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins -y
systemctl start jenkins
systemctl enable jenkins

# Add jenkins user to docker group
usermod -aG docker jenkins