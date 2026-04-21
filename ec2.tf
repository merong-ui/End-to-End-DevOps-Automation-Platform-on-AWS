# Get latest Ubuntu AMI automatically
# Only get AMIs created by Canonical (official Ubuntu images)
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance to host Jenkins and application
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id # auto-selected AMI
  instance_type = "t2.micro"
  key_name = "devops-new-key"   # SSH key for remote access

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "DevOps-App-Server"
  }
}
