terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                                       (recomended to start from here)
provider "aws" {

  region = "ap-south-1"

}


# -------------------------
# Create VPC
# -------------------------

resource "aws_vpc" "my_vpc" {

  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true

  enable_dns_hostnames = true

  tags = {

    Name = "terraform-vpc"

  }

}



# -------------------------
# Create Public Subnet
# -------------------------

resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.my_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {

    Name = "terraform-public-subnet"

  }

}


# -------------------------
# Create Internet Gateway
# -------------------------

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.my_vpc.id

  tags = {

    Name = "terraform-igw"

  }

}


# -------------------------
# Create Route Table
# -------------------------

resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.my_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {

    Name = "terraform-public-rt"

  }

}



# -------------------------
# Route Table Association
# -------------------------

resource "aws_route_table_association" "public_association" {


  subnet_id = aws_subnet.public_subnet.id


  route_table_id = aws_route_table.public_route_table.id

}


# -------------------------
# Create Security Group
# -------------------------

resource "aws_security_group" "my_security_group" {

  name = "terraform-security-group"

  description = "Allow SSH and HTTP"

  vpc_id = aws_vpc.my_vpc.id


  # SSH Access

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }


  # HTTP Access

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }


  # Allow all outgoing traffic

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "terraform-sg"
  }

}



# -------------------------
# Create EC2 Instance
# -------------------------

resource "aws_instance" "my_ec2" {

  ami = "ami-0f918f7e67a3323f0"

  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  # Existing AWS key pair name
  # Change this value

  key_name = "your-key-name"
  tags = {
    Name = "Terraform-Server"
  }
}


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

output "public_ip" {value = aws_instance.my_ec2.public_ip}

output "ssh_connection" {value = "ssh -i your-key.pem ec2-user@${aws_instance.my_ec2.public_ip}"}

Change only these two things:
Replace:
key_name = "your-key-name"
For example if your downloaded key is devops.pem then key_name = "devops"

Replace in output: your-key.pem with devops.pem

Then execute:
terraform init
terraform validate
terraform plan
terraform apply

After it finishes:
chmod 400 devops.pem
ssh -i devops.pem ec2-user@<public-ip>
