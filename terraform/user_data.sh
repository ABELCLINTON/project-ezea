#!/bin/bash
yum update -y

# Install Docker
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Java 21
wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm
rpm -ivh amazon-corretto-21-x64-linux-jdk.rpm

# Install Git
yum install git -y

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins -y
systemctl start jenkins
systemctl enable jenkins

# Add jenkins user to docker group
usermod -aG docker jenkins

# Install CloudWatch Agent
yum install amazon-cloudwatch-agent -y

# Configure and start CloudWatch Agent
cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/jenkins/jenkins.log",
            "log_group_name": "sampson-devops/jenkins",
            "log_stream_name": "{instance_id}/jenkins",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "sampson-devops/system",
            "log_stream_name": "{instance_id}/messages",
            "timezone": "UTC"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "SampsonDevOps/EC2",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent",
          "free"
        ],
        "metrics_collection_interval": 60,
        "resources": ["/"]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json