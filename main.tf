provider "aws" {
  region = "us-east-1" # replace with a region of your choice
}

resource "aws_key_pair" "key" {
  key_name   = "terraform-maryjane"
  public_key = file("~/.ssh/terraform-maryjane.pub") # replace with your path to public key
}


resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "chizzy_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gate_name" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "chizzy_igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate_name.id
  }

    tags = {
        Name = "chizzy_route_table"
    }

}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.route_table.id

}

resource "aws_security_group" "my_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "chizzy_sg"
  description = "Allow inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chizzy_sg"
  }
}

resource "aws_instance" "my_instance" {
  ami             = "ami-066784287e358dad1"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  key_name        = aws_key_pair.key.key_name
  security_groups = [aws_security_group.my_sg.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("downloads.pub") # replace with your path to private key
    host        = self.public_ip
  }

  tags = {
    name = "chizzy_instance"
  }


#   provisioner "file" {
#     source      = "app.py"
#     destination = "/home/ec2-user/app.py"
#   }
   
  
  
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Hello, World, welcome to chizzy's blog!",
#       "sudo yum update -y",
#       "sudo yum install -y python3-pip",
#       "cd /home/ec2-user",
#       "sudo pip3 install flask",
#       "sudo python3 app.py &"
#     ]
#   }


# depends_on = [aws_instance.my_instance]
  
  user_data = <<-EOF
            #!/bin/bash
            echo 'Hello, World, welcome to chizzy's blog!' > /home/ec2-user/index.html
            yum update -y
            yum install -y python3-pip
            cd /home/ec2-user
            pip3 install flask
            python3 /home/ec2-user/app.py &
            EOF
}
 
