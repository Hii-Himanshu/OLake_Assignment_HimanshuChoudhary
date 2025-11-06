// Create the VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "olake-vpc"
    Environment = var.environment    // E.g., "dev", "staging", "prod"
    Project     = "olake"
    ManagedBy   = "terraform"
  }
}


// creating the public subnet in VPC
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "olake-public-subnet"
    Environment = var.environment
    Project     = "olake"
    ManagedBy   = "terraform"
  }
}


// Create an Internet Gateway to allow communication between the VPC and the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  
  tags = {
    Name        = "olake-main-igw"
    Environment = var.environment
    Project     = "olake"
    ManagedBy   = "terraform"
  }
}

//Create a public route table that routes all internet-bound traffic (0.0.0.0/0)
// through the Internet Gateway.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "olake-public-rt"
    Environment = var.environment
    Project     = "olake"
    ManagedBy   = "terraform"
  }
}

// Associate the public subnet with the public route table.
// This ensures resources in the subnet can access the internet.
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}



