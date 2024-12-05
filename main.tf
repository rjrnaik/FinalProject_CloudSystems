terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  region = "us-east-1"
}

###############################
# VPCs
###############################

# VPC-Dev
resource "aws_vpc" "vpc_dev" {
  cidr_block = "10.15.0.0/16"
  tags = {
    Name = "VPC-Dev"
  }
}

# VPC-Shared
resource "aws_vpc" "vpc_shared" {
  cidr_block = "10.25.0.0/16"
  tags = {
    Name = "VPC-Shared"
  }
}

###############################
# Subnets
###############################

# VPC-Dev Subnets
resource "aws_subnet" "public_sn1_dev" {
  vpc_id            = aws_vpc.vpc_dev.id
  cidr_block        = "10.15.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-SN1-Dev"
  }
}

resource "aws_subnet" "public_sn2_dev" {
  vpc_id            = aws_vpc.vpc_dev.id
  cidr_block        = "10.15.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-SN2-Dev"
  }
}

resource "aws_subnet" "private_sn1_dev" {
  vpc_id     = aws_vpc.vpc_dev.id
  cidr_block = "10.15.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-SN1-Dev"
  }
}

resource "aws_subnet" "private_sn2_dev" {
  vpc_id     = aws_vpc.vpc_dev.id
  cidr_block = "10.15.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-SN2-Dev"
  }
}

# VPC-Shared Subnets
resource "aws_subnet" "public_sn1_shared" {
  vpc_id            = aws_vpc.vpc_shared.id
  cidr_block        = "10.25.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-SN1-Shared"
  }
}

resource "aws_subnet" "private_sn1_shared" {
  vpc_id     = aws_vpc.vpc_shared.id
  cidr_block = "10.25.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-SN1-Shared"
  }
}

###############################
# Internet Gateways
###############################

# Internet Gateway for VPC-Dev
resource "aws_internet_gateway" "igw_dev" {
  vpc_id = aws_vpc.vpc_dev.id
  tags = {
    Name = "igw-Dev"
  }
}

# Internet Gateway for VPC-Shared
resource "aws_internet_gateway" "igw_shared" {
  vpc_id = aws_vpc.vpc_shared.id
  tags = {
    Name = "igw-Shared"
  }
}

###############################
# NAT Gateways
###############################
 
# NAT Gateway for VPC-Dev
resource "aws_eip" "nat_eip_dev" {
  vpc = true
}

resource "aws_nat_gateway" "nat_dev" {
  allocation_id = aws_eip.nat_eip_dev.id
  subnet_id     = aws_subnet.public_sn1_dev.id
  tags = {
    Name = "nat-Dev"
  }
}

# NAT Gateway for VPC-Shared
resource "aws_eip" "nat_eip_shared" {
  vpc = true
}

resource "aws_nat_gateway" "nat_shared" {
  allocation_id = aws_eip.nat_eip_shared.id
  subnet_id     = aws_subnet.public_sn1_shared.id
  tags = {
    Name = "nat-Shared"
  }
}

###############################
# Route Tables
###############################

# Route Table for Public Subnets (VPC-Dev)
resource "aws_route_table" "public_rt_dev" {
  vpc_id = aws_vpc.vpc_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_dev.id
  }
  tags = {
    Name = "public-rt-Dev"
  }
}

resource "aws_route_table_association" "public_rt_assoc_sn1_dev" {
  subnet_id      = aws_subnet.public_sn1_dev.id
  route_table_id = aws_route_table.public_rt_dev.id
}

resource "aws_route_table_association" "public_rt_assoc_sn2_dev" {
  subnet_id      = aws_subnet.public_sn2_dev.id
  route_table_id = aws_route_table.public_rt_dev.id
}

# Route Table for Private Subnets (VPC-Dev)
resource "aws_route_table" "private_rt_dev" {
  vpc_id = aws_vpc.vpc_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_dev.id
  }
  tags = {
    Name = "private-rt-Dev"
  }
}

resource "aws_route_table_association" "private_rt_assoc_sn1_dev" {
  subnet_id      = aws_subnet.private_sn1_dev.id
  route_table_id = aws_route_table.private_rt_dev.id
}

resource "aws_route_table_association" "private_rt_assoc_sn2_dev" {
  subnet_id      = aws_subnet.private_sn2_dev.id
  route_table_id = aws_route_table.private_rt_dev.id
}

# Route Table for Public Subnets (VPC-Shared)
resource "aws_route_table" "shared_public_rt" {
  vpc_id = aws_vpc.vpc_shared.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_shared.id
  }
  tags = {
    Name = "shared-public-route-table"
  }
}

resource "aws_route_table_association" "shared_public_rt_assoc" {
  subnet_id      = aws_subnet.public_sn1_shared.id
  route_table_id = aws_route_table.shared_public_rt.id
}

# Route Table for Private Subnets (VPC-Shared)
resource "aws_route_table" "shared_private_rt" {
  vpc_id = aws_vpc.vpc_shared.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_shared.id
  }
  tags = {
    Name = "shared-private-route-table"
  }
}

resource "aws_route_table_association" "shared_private_rt_assoc" {
  subnet_id      = aws_subnet.private_sn1_shared.id
  route_table_id = aws_route_table.shared_private_rt.id
}

###############################
# Outputs
###############################

output "vpc_dev_id" {
  value = aws_vpc.vpc_dev.id
}

output "vpc_shared_id" {
  value = aws_vpc.vpc_shared.id
}
