# You are a DevOps Engineer working for a company that wants to automate infrastructure deployment using Terraform. You have been tasked with developing a Terraform configuration to create the following AWS services:
# 1.	VPC with a CIDR block of 10.0.0.0/16
# 2.	Two Subnets (one public, one private)
# 3.	EC2 Instance in the public subnet with an SSH key pair
# 4.	Security Group to allow SSH (port 22) and HTTP (port 80)
# 5.	KMS Key to Encrypt S3 Bucket
# 6.	S3 Bucket for storing logs with encryption enabled
# 7.	DynamoDB Table for session storage
# Task Requirements
# Write a Terraform configuration that does the following:
# ✅ Create a VPC with CIDR 10.0.0.0/16
# ✅ Create a Public Subnet (10.0.1.0/24) and a Private Subnet (10.0.2.0/24)
# ✅ Attach an Internet Gateway to the VPC and route public subnet traffic to the internet
# ✅ Create a Security Group allowing SSH (22) and HTTP (80)
# ✅ Launch an EC2 instance in the public subnet
# ✅ Create a kMS Key name "S3-KMS" to be used for S3 Bucket Encryption
# ✅ Create an S3 bucket named "exam-logs-<random_id>" with server-side encryption
# ✅ Create a DynamoDB table with a SessionId as the primary key
# Note: All Your Code Need to Push to a Github Project.
# Capture Screenshot of each resource as answer

resource "aws_vpc" "VPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.publicsub_cidr

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = var.privatesub_cidr

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "projectIGW" {
  vpc_id = aws_vpc.VPC.id



  tags = {
    Name = "projectIGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.projectIGW.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "SecurityGroup" {
  name        = "SecurityGroupTraffic"
  description = "Allow inbound traffic on 22, 80 and all outbound traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server-instance" {
  ami             = var.ami
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.SecurityGroup.id]
  associate_public_ip_address  = true
  instance_type   = var.instance_type

  tags = {
    Name = "server-instance"
  }
}

resource "aws_kms_key" "S3-KMS" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "S3-KMS"
  }
}

resource "aws_s3_bucket" "exam-logs-oct16" {
  bucket = "exam-logs-oct16"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "BucketEncryption" {
  bucket = aws_s3_bucket.exam-logs-oct16.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.S3-KMS.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "SessionTable" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "SessionId"

  attribute {
    name = "SessionId"
    type = "S"
  }
}