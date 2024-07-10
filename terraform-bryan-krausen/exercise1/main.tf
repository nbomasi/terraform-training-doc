# Configure the AWS Provider, using aws cli configure


# Static credential method
# provider "aws" {
#   region     = "us-east-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
# }

## Environmental variable method
# provider "aws" {

# }
# Note the foolowings will be declared on your terminal, the syntax depends on your OS/ Si
# $ export AWS_ACCESS_KEY_ID="anaccesskey"
# $ export AWS_SECRET_ACCESS_KEY="asecretkey"
# $ export AWS_DEFAULT_REGION="us-east-1"

## Shared credentials/configuration file
# provider "aws" {
#   region                  = "us-east-1"
#   shared_credentials_file = "/Users/tf_user/.aws/creds" ## This path depends on the location of aws credentials on your OS 
#   profile                 = "customprofile"
# }

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
# data "aws_region" "current" {}

# resource "random_string" "random" {
#   length = 16
# }

# #Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
  }
}

#Deploy the private subnets
# resource "aws_subnet" "private_subnets" {
#   for_each          = var.private_subnets
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
#   availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

#   tags = {
#     Name      = each.key
    # Terraform = "true"
#   }
# }

#Deploy the public subnets

resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value+100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_public_rtb"
    Terraform = "true"
  }
}

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     # gateway_id     = aws_internet_gateway.internet_gateway.id
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }
#   tags = {
#     Name      = "demo_private_rtb"
#     Terraform = "true"
#   }
# }

#Create route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

# resource "aws_route_table_association" "private" {
#   depends_on     = [aws_subnet.private_subnets]
#   route_table_id = aws_route_table.private_route_table.id
#   for_each       = aws_subnet.private_subnets
#   subnet_id      = each.value.id
# }

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_igw"
  }
}

# #Create EIP for NAT Gateway
# resource "aws_eip" "nat_gateway_eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.internet_gateway]
#   tags = {
#     Name = "demo_igw_eip"
#   }
# }

# #Create NAT Gateway
# resource "aws_nat_gateway" "nat_gateway" {
#   depends_on    = [aws_subnet.public_subnets]
#   allocation_id = aws_eip.nat_gateway_eip.id
#   subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
#   tags = {
#     Name = "demo_nat_gateway"
#   }
# }

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# # Terraform Resource Block - To Build EC2 instance in Public Subnet
# resource "aws_instance" "web_server3" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
#   tags = {
#     Name = "Ubuntu EC2 Server"
#   }
# }

# resource "aws_security_group" "my-new-security-group" {
#   name        = "web_server_inbound"
#   description = "Allow inbound traffic on tcp/443"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description = "Allow 443 from the Internet"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name    = "web_server_inbound"
#     Purpose = "Intro to Resource Blocks Lab"
#   }
# }

# resource "random_id" "randomness" {
#   byte_length = 16
# }

# resource "aws_s3_bucket" "my-new-S3-bucket" {
#   bucket = "my-new-tf-test-bucket-${random_id.randomness.hex}"

#   tags = {
#     Name    = "My S3 Bucket"
#     Purpose = "Intro to Resource Blocks Lab"
#   }
# }

# resource "aws_subnet" "variables-subnet1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.250.0/24"
#   availability_zone       = "eu-north-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name      = "sub-variables-eu-north-1a"
#     Terraform = "true"
#   }
# }

# resource "aws_subnet" "variables-subnet2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.variables_sub_cidr
#   availability_zone       = var.variables_sub_az
#   map_public_ip_on_launch = var.variables_sub_auto_ip

#   tags = {
#     Name      = "sub-variables-${var.variables_sub_az}"
#     Terraform = "true"
#   }
# }

# locals {
#   team = "api_mgmt_dev"
#   application = "corp_api"
#   server_name = "ec2-${aws_vpc.vpc.tags["Environment"]}-api-${var.variables_sub_az}"
# }

# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
#   tags = {
#     Name = local.server_name
#     Owner = local.team
#     App = local.application
#   }
# }

# #Define the VPC
# resource "aws_vpc" "vpc" {
#   cidr_block = var.vpc_cidr

#   tags = {
#     Name        = var.vpc_name
#     Environment = "demo_environment"
#     Terraform   = "true"
#     Region      = data.aws_region.current.name

#   }
# }

# # Terraform Data Block - Lookup Ubuntu 22.04
# data "aws_ami" "ubuntu_22_04" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   owners = ["099720109477"]
# }

# #- using the querried image to create ec2 instance
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups             = [aws_security_group.vpc-ping.id]
  associate_public_ip_address = true
  tags = {
    Name = "Web EC2 Server"
  }
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

# # Generating keypairs using TLS provider
# resource "local_file" "private_key_pem" {
#   content  = tls_private_key.generated.private_key_pem
#   filename = "MyAWSKey.pem"
# }

# # Uploading keypairs
# resource "aws_key_pair" "generated" {
#   key_name   = "MyAWSKey"
#   public_key = tls_private_key.generated.public_key_openssh

#   lifecycle {
#     ignore_changes = [key_name]
#   }
# }

# # Opening SSH Port
# # Security Groups

# resource "aws_security_group" "ingress-ssh" {
#   name   = "allow-all-ssh"
#   vpc_id = aws_vpc.vpc.id
#   ingress {
#     cidr_blocks = [
#       "0.0.0.0/0"
#     ]
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#   }
#   // Terraform removes the default rule
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create Security Group - Web Traffic
# resource "aws_security_group" "vpc-web" {
#   name        = "vpc-web-${terraform.workspace}"
#   vpc_id      = aws_vpc.vpc.id
#   description = "Web Traffic"
#   ingress {
#     description = "Allow Port 80"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow Port 443"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all ip and ports outbound"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "vpc-ping" {
  name        = "vpc-ping"
  vpc_id      = aws_vpc.vpc.id
  description = "ICMP for Ping Access"
  ingress {
    description = "Allow ICMP Traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }

}

# locals {
#   maximum = max(var.num_1, var.num_2, var.num_3)
#   minimum = min(var.num_1, var.num_2, var.num_3, 44, 20)
# }

# output "max_value" {
#   value = local.maximum
# }

# output "min_value" {
#   value = local.minimum
# }

# resource "aws_instance" "ubuntu_server2" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = "t3.micro"
#   subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
#   security_groups             = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id] 
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.generated.key_name
#   connection {
#     user        = "ubuntu"
#     private_key = tls_private_key.generated.private_key_pem
#     host        = self.public_ip
#   }

#   tags = {
#     Name = "Ubuntu EC2 Server2"
#   }

#   lifecycle {
#     ignore_changes = [security_groups]
#   }

# # Leave the first part of the block unchanged and create our `local-exec` provisioner
#   provisioner "local-exec" {
#     command = "chmod 600 ${local_file.private_key_pem.filename}"
#   }

#     provisioner "remote-exec" {
#     inline = [
#       "sudo rm -rf /tmp",
#       "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
#       "sudo sh /tmp/assets/setup-web.sh",
#     ]
#   }
# }

# module "server" {
#   source          = "./modules/server"
#   ami             = data.aws_ami.ubuntu.id
#   subnet_id       = aws_subnet.public_subnets["public_subnet_3"].id
#   security_groups = [aws_security_group.vpc-ping.id, 
#   aws_security_group.ingress-ssh.id, 
#   aws_security_group.vpc-web.id]
# }

# module "server_subnet_1" {
#   source          = "./modules/server"
#   ami             = data.aws_ami.ubuntu.id
#   subnet_id       = aws_subnet.public_subnets["public_subnet_1"].id
#   security_groups = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
# }

# module "server_subnet_2" {
#   source          = "./modules/server"
#   ami             = data.aws_ami.ubuntu.id
#   subnet_id       = aws_subnet.public_subnets["public_subnet_2"].id
#   security_groups = [aws_security_group.vpc-ping.id, 
#   aws_security_group.ingress-ssh.id, 
#   aws_security_group.vpc-web.id]
# }

# module "server_subnet_3" {
#   source          = "./modules/web_server"
#   ami             = data.aws_ami.ubuntu.id
#   key_name        = aws_key_pair.generated.key_name
#   user            = "ubuntu"
#   private_key     = tls_private_key.generated.private_key_pem
#   subnet_id       = aws_subnet.public_subnets["public_subnet_1"].id
#   security_groups = [aws_security_group.vpc-ping.id, 
#   aws_security_group.ingress-ssh.id, 
#   aws_security_group.vpc-web.id]
# }

# resource "aws_subnet" "list_subnet" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.200.0/24"
#   availability_zone = var.eu-north-1-azs[0]
# }

# Using List
# resource "aws_subnet" "list_subnet-map1" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.ip[var.environment]
#   availability_zone = var.eu-north-1-azs[0]
# }

# # Using Map
# resource "aws_subnet" "list_subnet_map" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.ip["prod"]
#   availability_zone = var.eu-north-1-azs[0]
# }

# resource "aws_subnet" "list_subnet_loop" {
#   for_each          = var.ip
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = each.value
#   availability_zone = var.eu-north-1-azs[0]
# }

# data "aws_s3_bucket" "data_bucket" {
#   bucket = "boma-s3-bucket"
# }

# data "aws_s3_bucket" "data_bucket" {
#   bucket = "onyeka123456"
# }

# resource "aws_iam_policy" "policy" {
#   name        = "data_bucket_policy"
#   description = "Deny access to my bucket"
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:Get*",
#                 "s3:List*"
#             ],
#             "Resource": "${data.aws_s3_bucket.data_bucket.arn}"
#         }
#     ]
#   })
# }

# # Nested Security Group and rules
# resource "aws_security_group" "main-nexted" {
#   name   = "core-sg1"
#   vpc_id = aws_vpc.vpc.id

#   ingress {
#     description = "Port 443"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Port 80"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Dynamic Security Group rule using locals
# locals {
#   ingress_rules = [{
#       port        = 3306
#       description = "mysql port"
#     },
#     {
#       port        = 2049
#       description = "NFS port"
#     }
#   ]
# }

# resource "aws_security_group" "main-dynamic1" {
#   name   = "core-sg2"
#   vpc_id = aws_vpc.vpc.id

#   dynamic "ingress" {
#     for_each = local.ingress_rules

#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# # Dynamic Security Group rule using Map

# variable "web_ingress" {
#   type = map(object(
#     {
#       description = string
#       port        = number
#       protocol    = string
#       cidr_blocks = list(string)
#     }
#   ))
#   default = {
#     "90" = {
#       description = "Port 90"
#       port        = 90
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#     "43" = {
#       description = "Port 443"
#       port        = 43
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# resource "aws_security_group" "main-dynamic2" {
#   name = "core-sg3"

#   vpc_id = aws_vpc.vpc.id

#   dynamic "ingress" {
#     for_each = var.web_ingress
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }
# }

# cidrsubnet("172.18.0.0/24", 8, 1)

# cidrsubnets("10.1.0.0/16", 4, 4, 8)

# cidrsubnets("10.0.0.0/16", 4, 4, 8)

# resource "aws_vpc" "vpc" {
#   cidr_block = var.vpc_cidr

#   tags = {
#     Name        = var.vpc_name
#     Environment = var.environment
#     Terraform   = "true"
#   }

#   enable_dns_hostnames = true
# }


resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey${var.environment}"
  public_key = tls_private_key.generated.public_key_openssh
}