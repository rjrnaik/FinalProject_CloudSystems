
# Security Group for Bastion
resource "aws_security_group" "bastion_sg" {
  vpc_id = "vpc-0e09d49919f3dbcb3" # Replace with your VPC ID (shared VPC)
 
  ingress {
    description = "Allow SSH from MyLaptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["142.55.0.11/32"] # Replace with your laptop's public IP
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "bastion-sg"
  }
}
 


# Bastion Instance (Public-SN1 in VPC-Shared)
resource "aws_instance" "bastion" {
  ami                    = "ami-0453ec754f44f9a4a" # Amazon Linux 2 AMI (Change if needed)
  instance_type          = "t2.micro"
  subnet_id              = "subnet-095b8bb04b6787698" # Replace with Public-SN1 Subnet ID
  associate_public_ip_address = true
  security_groups        = [aws_security_group.bastion_sg.id]
  key_name               = "finalprojectkey"
 
  tags = {
    Name = "bastion"
  }
}


###############################
# Outputs
###############################
 
# Bastion Public IP
output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the Bastion host"
}
