# ✅ Set up AWS provider
provider "aws" {
  region = "us-east-1"
}

# ✅ Get the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ✅ Create a VPC with public DNS enabled
resource "aws_vpc" "christanyk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true   # Enables DNS resolution
  enable_dns_hostnames = true   # Enables DNS hostnames
  tags = { Name = "christanyk-vpc" }
}

# ✅ Create a Public Subnet in the VPC
resource "aws_subnet" "christanyk_subnet" {
  vpc_id                  = aws_vpc.christanyk_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# ✅ Create an Internet Gateway & Attach to VPC
resource "aws_internet_gateway" "christanyk_igw" {
  vpc_id = aws_vpc.christanyk_vpc.id
  tags = { Name = "christanyk-igw" }
}

# ✅ Create a Route Table for Internet Access
resource "aws_route_table" "christanyk_rt" {
  vpc_id = aws_vpc.christanyk_vpc.id
}

# ✅ Add a Default Route to Internet Gateway
resource "aws_route" "christanyk_route" {
  route_table_id         = aws_route_table.christanyk_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.christanyk_igw.id
}

# ✅ Associate the Route Table with the Subnet
resource "aws_route_table_association" "christanyk_rta" {
  subnet_id      = aws_subnet.christanyk_subnet.id
  route_table_id = aws_route_table.christanyk_rt.id
}

# ✅ Create a Security Group for SSH
resource "aws_security_group" "ssh_access" {
  vpc_id      = aws_vpc.christanyk_vpc.id
  name        = "christanyk-ssh-access"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ✅ Create EC2 Instance with Public IP
resource "aws_instance" "christanyk" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "christanyk"  # Ensure this key exists in AWS
  subnet_id              = aws_subnet.christanyk_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true  # Ensures Public IP is assigned

  tags = { Name = "christanyk" }
}

# ✅ Output Public IP, Public DNS, and SSH Command
output "ec2_public_ip" {
  description = "🚀 Public IP Address of the EC2 instance"
  value       = aws_instance.christanyk.public_ip
}

output "ec2_public_dns" {
  description = "🌐 Public DNS Name of the EC2 instance"
  value       = aws_instance.christanyk.public_dns
}
