terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48" // Keep version unchanged
    }
  }
}



provider "aws" {
  region  = "us-east-1"
  version = "~> 5.48" // Keep version unchanged
}

resource "aws_security_group" "http_server_sg" {
  name        = "http_server_sg" // Removed dash as it's not recommended in security group names
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_default_vpc.default.id // Uncomment and use the default VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP traffic"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound SSH traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // Use string "-1" for all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_default_vpc" "default" {
  #vpc_id = "vpc-01bd7892d378924f7"
}



resource "aws_instance" "http_server" {
  #ami                   = "ami-045602374a1982480"
  ami           = data.aws_ami.aws-linux-2-latest.id
  key_name      = "default-ec2"
  instance_type = "t2.micro"
  #vpc_security_group_ids = "sg-0e1a655fa973b0bf1"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  #subnet_id             = "subnet-0d1b38adb0bfa3d31"
  subnet_id = data.aws_subnets.default_subnets.ids[0]

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "echo 'Welcome To My HTTP server ${self.public_dns}' | sudo tee /var/www/html/index.html"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }
}





