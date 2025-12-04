# module "s3bucket1" {
#   source = "./modules/s3"
# }

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create 3 Subnets
resource "aws_subnet" "subnets" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "subnet-${count.index + 1}"
  }
}

# Fetch availability zones
data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_association" {
  count          = 3
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

module "sggrp" {
  source = "./modules/securitygrp"
  jenkins_sg_name = "jenkins-server"
}

module "jenkins-server" {
  source = "./modules/ec2"
  ami_id = data.aws_ssm_parameter.al2.value
  key_name = aws_key_pair.jenkins_key.key_name
  sg_name = [module.sggrp.jenkins_sg_name]
}

data "aws_ssm_parameter" "al2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key"      # Name of the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}