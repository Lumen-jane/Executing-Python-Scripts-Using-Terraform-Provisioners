Here is a breakdown of this project:

### Project Summary: Executing Python Scripts Using Terraform Provisioners

**Project Objective:**
The goal of this project is to automate the deployment and execution of a Python script on an AWS EC2 instance using Terraform. The Python script, `app.py`, will be deployed to an EC2 instance, and the necessary environment setup will be handled automatically.

**Key Steps and Description:**

1. Initial Setup:
   - Create SSH Key Pair: I generated an SSH key pair to securely connect to the EC2 instance using this command:
      "ssh-keygen -t rsa"

   Then The Terraform script was configured to set up an AWS infrastructure, including a VPC, subnet, security group, and EC2 instance.

2. Infrastructure Deployment:
   - VPC and Subnet Creation: A Virtual Private Cloud (VPC) and a subnet were created to host the EC2 instance. The subnet was configured to automatically assign public IPs to instances launched within it.
   - Security Group Setup: A security group was configured to allow SSH access (port 22) to the EC2 instance.
   - Internet Gateway and Route Table: An internet gateway was attached to the VPC, and the route table was updated to allow outbound internet access from the EC2 instance.
   - my route table associated with your subnet and route to the internet gateway to allow public internet access.
     
3. EC2 Instance Provisioning:
   - EC2 Instance Setup: An EC2 instance was provisioned within the subnet using an Amazon Machine Image (AMI) and the `t2.micro` instance type. The SSH key pair was associated with the instance to enable secure login.
   - User Data and Provisioners:
     - User Data Script: A user data script was added to the EC2 instance to install Python and Flask, then run the `app.py` script.
     - Terraform Provisioners: Terraform provisioners were meant to copy the `app.py` script to the EC2 instance and execute it.

4. Execution and Testing:
   - Script Execution: The Python script was meant to execute automatically on the EC2 instance but it didn't.
  
The idea was to use provisioners in running the project to prevent manual intervention and to make it more available but i had to use User Data script instead.
