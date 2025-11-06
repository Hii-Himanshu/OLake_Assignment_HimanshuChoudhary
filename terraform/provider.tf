terraform {
  required_version = ">= 1.4.0"

  required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.0"
  }
}

}


// Configure the AWS provider with the region from variables
provider "aws" {
  region = var.aws_region
}




