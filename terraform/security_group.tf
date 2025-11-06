// Create a security group for OLake VM allowing SSH and web UI access
resource "aws_security_group" "olake_sg" {
name = "olake-sg-${var.environment}-${var.aws_region}"
description = "Allow SSH (22) and OLake UI (8000)"
vpc_id =  aws_vpc.my-vpc.id

 // Allow SSH from anywhere (not recommended for production)
ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
}

// Allow external access to the OLake web UI (default port 8000)
ingress {
description = "OLake UI"
from_port = 8000
to_port = 8000
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

 // Allow all outbound traffic (for downloading dependencies from the internet)
egress {
description = "Allow all outbound"
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name        = "olake-sg-${var.environment}"
    Environment = var.environment
    Project     = "olake"
    ManagedBy   = "terraform"
  }
}

