variable "region" {
  type        = string
  description = "Enter Your AWS Region"
  default     = "ca-central-1"
}

variable "vpc_cidr" {
  type        = string
  description = "Enter Your VPC CIDR Range"
  default     = "10.0.0.0/16"
}

variable "publicsub_cidr" {
  type        = string
  description = "Enter Your subnet CIDR Range"
  default     = "10.0.1.0/24"
}

variable "privatesub_cidr" {
  type        = string
  description = "Enter Your subnet CIDR Range"
  default     = "10.0.2.0/24"
}

variable "ami" {
  type        = string
  description = "Enter Your EC2 AMI ID"
  default     = "ami-03814457ed908d8f6"
}

variable "instance_type" {
  type        = string
  description = "Enter Your EC2 instance type"
  default     = "t3.micro"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Enter Your DynamoDB Table Name"
  default     = "SessionTable"
}
