# Output EC2 public IP (used for SSH, Jenkins, webhook)
output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_eip.jenkins_eip.public_ip
}

# Output EC2 instance ID
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}
