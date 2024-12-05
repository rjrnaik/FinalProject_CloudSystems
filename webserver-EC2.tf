# Security Group for Web Servers in VPC-Dev
resource "aws_security_group" "webserver_sg" {
  vpc_id = "vpc-079a8b38f274e63a7" # Replace with your VPC ID (Dev VPC)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-sg"
  }
}

# Ingress Rule for SSH from Bastion Security Group
resource "aws_security_group_rule" "ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.webserver_sg.id
  source_security_group_id = "sg-05ec9ac8bc1d49b5d" # Bastion SG in VPC-Shared
}

# Web Server 1 (Private Subnet 1 in VPC-Dev)
resource "aws_instance" "webserver1" {
  ami                         = "ami-0453ec754f44f9a4a" # Amazon Linux 2 AMI (Change if needed)
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0d2006cc8acd21c97" # Replace with Private Subnet 1 ID
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  key_name                    = "finalprojectkey"
  associate_public_ip_address = false # Do not assign a public IP

  tags = {
    Name = "webserver1"
  }
}

# Web Server 2 (Private Subnet 2 in VPC-Dev)
resource "aws_instance" "webserver2" {
  ami                         = "ami-0453ec754f44f9a4a" # Amazon Linux 2 AMI (Change if needed)
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0a5c2766c35183e46" # Replace with Private Subnet 2 ID
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]
  key_name                    = "finalprojectkey"
  associate_public_ip_address = false # Do not assign a public IP

  tags = {
    Name = "webserver2"
  }
}

# Outputs
# Web Server 1 Private IP
output "webserver1_private_ip" {
  value       = aws_instance.webserver1.private_ip
  description = "Private IP of Web Server 1"
}

# Web Server 2 Private IP
output "webserver2_private_ip" {
  value       = aws_instance.webserver2.private_ip
  description = "Private IP of Web Server 2"
}
