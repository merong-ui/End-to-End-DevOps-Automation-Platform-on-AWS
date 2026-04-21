# Elastic IP to keep a fixed public IP for Jenkins/webhook
resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.app_server.id  # Attach to EC2

  tags = {
    Name = "DevOps-EIP"
  }
}
