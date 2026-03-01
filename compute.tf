# 1. Fetch the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# The Platform Server
resource "aws_instance" "platform_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.medium"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.platform.id]

  key_name = "vertex-key"

  # The Boot-up Script
  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | sh -
              EOF

  tags = {
    Name = "vertex-platform-server"
  }
}


output "platform_ip" {
  value = aws_instance.platform_server.public_ip
}