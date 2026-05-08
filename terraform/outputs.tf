output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "app_url" {
  description = "Application URL"
  value       = "http://${module.ec2.instance_public_ip}:5000"
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${module.ec2.instance_public_ip}:8080"
}