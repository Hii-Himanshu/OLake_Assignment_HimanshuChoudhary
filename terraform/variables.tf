variable "aws_region" {
description = "AWS region"
type = string
default = "us-east-1"
}


variable "instance_ami" {
  description = "Instance AMI"
  type = string
  default = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  description = "Instance type"
  type = string
  default = "t3.xlarge"
}

variable "environment" {
  description = "The environment for deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"  
}

