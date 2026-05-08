variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI for us-east-1"
  default     = "ami-0c02fb55956c7d316"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}