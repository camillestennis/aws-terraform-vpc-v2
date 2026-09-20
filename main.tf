terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- Networking: VPC + public subnet ---

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "portfolio-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "portfolio-public-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "portfolio-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "portfolio-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --- Security group: SSH only from your IP would go here later ---

resource "aws_security_group" "web" {
  name        = "portfolio-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # we'll tighten this later
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "portfolio-sg"
  }
}

# --- EC2 instance ---

resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2, us-east-1
  instance_type           = "t3.micro"
  subnet_id                = aws_subnet.public.id
  vpc_security_group_ids   = [aws_security_group.web.id]
  key_name               = "portfolio-key"
  tags = {
    Name = "portfolio-ec2"
  }
}

# --- S3 bucket ---

resource "aws_s3_bucket" "portfolio" {
  bucket = "camille-stennis-portfolio-${random_id.suffix.hex}"

  tags = {
    Name = "portfolio-bucket"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
