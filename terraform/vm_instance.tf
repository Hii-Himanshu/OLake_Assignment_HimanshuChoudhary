// Create an EC2 instance for running Minikube and Helm deployments.
resource "aws_instance" "olake_vm" {
  ami           = var.instance_ami
  instance_type = var.instance_type              // Should support 4 vCPU and 16GB RAM
  key_name = aws_key_pair.olake_key_pair.key_name

  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.olake_sg.id]
  root_block_device {
    volume_size = 50                       # 50 GB storage
    volume_type = "gp3"
    delete_on_termination = true
  }

   tags = {
    Name        = "olake-minikube-vm"
    Environment = var.environment     // E.g., "dev", "staging", "prod"
    Project     = "olake"
    ManagedBy   = "terraform"
  }

  // Bootstrap script to install dependencies and starting minikube and configuring it and enabling required addons
  
  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              sudo apt update -y
              sudo apt upgrade -y

              # Install Docker
              sudo apt install -y ca-certificates curl gnupg lsb-release
              sudo mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
                https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt update -y
              sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              sudo usermod -aG docker ubuntu
              sudo chmod 777 /var/run/docker.sock

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              # Install Minikube
              curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
              sudo install minikube-linux-amd64 /usr/local/bin/minikube

              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

              # Start Minikube
              sudo -u ubuntu minikube start --driver=docker --cpus=3 --memory=6144

              

              # Enable addons
              sudo -u ubuntu minikube addons enable ingress
              sudo -u ubuntu minikube addons enable storage-provisioner


              sudo -u ubuntu minikube update-context

              # Install Terrform for deploying Olake using Helm
              sudo apt install -y gnupg software-properties-common curl
              curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
              echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
              sudo apt update -y
              sudo apt install -y terraform   
              EOF


// Copy Terraform files to instance for Helm deployment

  provisioner "file" {
    source      = "../files_for_VM"  
    destination = "/home/ubuntu/my-tf-files"
  

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.olake_key.private_key_pem
    host        = self.public_ip
}
  
  }
  
  
}


  # Generate a new SSH key pair
resource "tls_private_key" "olake_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the public key
resource "aws_key_pair" "olake_key_pair" {
  key_name   = "olake-keypair"
  public_key = tls_private_key.olake_key.public_key_openssh
}

# Save private key locally (so you can use SSH to connect)
resource "local_file" "private_key" {
  content         = tls_private_key.olake_key.private_key_pem
  filename        = "${path.module}/olake-keypair.pem"
  file_permission = "0400"
}



           







