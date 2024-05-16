# project-1-terraform-ec2-instace-and-http-server
AWS Provider Configuration:
Your project starts by defining the required AWS provider with the specific region (us-east-1) and version (~> 5.48). This ensures Terraform uses the correct AWS services and APIs to manage your resources.

AWS Security Group (aws_security_group):
Name: http_server_sg
Description: Allows HTTP and SSH traffic.
Ingress Rules:
Allows inbound HTTP traffic (TCP port 80) from anywhere (0.0.0.0/0).
Allows inbound SSH traffic (TCP port 22) from anywhere (0.0.0.0/0).
Egress Rule: Allows all outbound traffic to anywhere (0.0.0.0/0).
Default VPC (aws_default_vpc):
The default VPC is used, though you've commented out the vpc_id attribute. This means Terraform will use the default VPC provided by AWS in the specified region.

AWS Instance (aws_instance):
AMI: Uses the latest AWS Linux 2 AMI.
Instance Type: t2.micro.
Key Pair: Uses the default EC2 key pair for SSH access.
Security Groups: Associates the instance with the previously defined security group (http_server_sg).
Subnet: Uses the first subnet from the default subnets in the specified region.
Provisioner (Remote Execution): Executes commands remotely on the instance after it's provisioned. Installs Apache HTTP server, starts it, and creates an HTML file with a welcome message including the instance's public DNS.
Connection: Specifies SSH connection details, including the username (ec2-user), the instance's public IP, and the private key file.
Project Summary:
Your project automates the provisioning of an AWS EC2 instance running a basic HTTP server using Terraform.
It ensures security by defining a specific security group (http_server_sg) allowing only HTTP (port 80) and SSH (port 22) traffic.
The instance is configured to use the latest AWS Linux 2 AMI and the smallest instance type (t2.micro).
The provisioner installs and starts the Apache HTTP server and creates an HTML file with a welcome message.
SSH access is facilitated using the default EC2 key pair.
Considerations:
Ensure you have the necessary AWS credentials configured to execute Terraform.
Review and adjust security settings and resources based on your specific requirements and best practices.
Regularly update your Terraform configurations to reflect any changes in infrastructure or security requirements.
