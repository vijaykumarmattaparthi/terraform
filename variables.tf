variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "key_pair_name" {
  description = "Name of the existing AWS key pair (must already exist in your AWS account)"
  type        = string
  # No default - you must provide this, e.g. via terraform.tfvars or -var flag
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into the instance (restrict this to your IP for better security)"
  type        = string
  default     = "0.0.0.0/0"
}
