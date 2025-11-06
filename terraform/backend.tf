terraform {
  backend "s3" {
    bucket = "my-olake-bucket5855"
    key = "Olake-Terraform/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "Lock-Files"
    encrypt = true
  }
}