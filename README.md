# OLake – DevOps Intern Assignment



> **Tested on:** Ubuntu 22.04 LTS (EC2), Terraform v1.13.4, Docker v28.5.2, Minikube v1.37.0, Helm v3.19.0  .

---

## Prerequisites



* **Cloud provider used:** AWS
* AWS account with permissions to create: EC2, VPC, Subnets, Security Groups, IAM Role/Instance Profile, and EBS volumes.



* **Terraform** `>= 1.4` (tested with Terraform v1.13.4)



### Terraform Remote State 

* S3 bucket + DynamoDB table for state + locking



## End‑to‑End Deployment

### Step 0: S3 bucket + DynamoDB table for state + locking
```bash
# creating the s3 bucket for statefile
aws s3api create-bucket --bucket my-bucket-nameeeeeee --region us-east-1

# Create a DynamoDB table for Terraform state locking to prevent concurrent runs

aws dynamodb create-table \
  --table-name Lock-Files \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```



### Step 1: Clone the Repo 

```bash
# Get code
git clone https://github.com/Hii-Himanshu/OLake_Assignment_HimanshuChoudhary.git

# Go into terraform directory
cd OLake_Assignment_HimanshuChoudhary/terraform

```

### Step 2: Initialize Terraform and Apply
```bash
# Initialize Terraform
terraform init

# Terraform apply
terraform apply -auto-approve 

```

### Wait, Creating everything ...

> **Now wait a few minutes for the infrastructure to be set up. This includes installing dependencies such as Docker, Minikube, kubectl, Helm, and Terraform on the virtual machine, as well as enabling the required addons through the cloud-init user data script.**

### **Now you will get:**
* `An SSH key pair has been created in the Terraform folder; you can now use it to connect via SSH.`
* `vm_public_ip`

### Step 3: Now SSH on to the VM
```bash
ssh -i olake-keypair.pem ubuntu@vm_public_ip
```

> ## Note: Run the SSH command from the terraform/ directory unless you specify the full path to olake-keypair.pem.

### Once connected to the VM, verify Docker, kubectl, Minikube (with addons), Helm, and Terraform are installed.

### Check for the my-tf-files directory—it contains the Terraform and values.yaml files needed to deploy OLake via the Helm provider.






### Step 4: Deploy OLake via Terraform Helm Provider

> Now, we are in VM (minikube VM)
```bash
# To verify that the my-tf-files directory was successfully copied from your local machine to the VM, run the following command inside your VM:
ls                                                              # this command we have to run in VM

# Now, go to directory my-tf-files
cd my-tf-files                                                # this command we have to run in VM


terraform init                                                 # this command we have to run in VM
terraform apply -auto-approve                                   # this command we have to run in VM
```
### Step 5: Now just use kubectl port-forward to forward the Ingress controller service to a port on the VM:

```bash
kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8000:80 --address 0.0.0.0

```

* `--address 0.0.0.0 (allows external access from any IP (not just localhost)`



### Step 6: Access the OLake UI

* Open browser: **`http://<EC2_PUBLIC_IP>:8000`** 




### Step 7: Cleanup Instructions (To destroy infrastructure)

```bash
terraform destroy # on terraform directory (not on VM) 
```




