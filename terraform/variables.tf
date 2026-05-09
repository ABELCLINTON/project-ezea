variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging"
  default     = "ezea-devops"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Public subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  default     = "C:/Users/ABELCLINTON/.ssh/id_rsa.pub"
}