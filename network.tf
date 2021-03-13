provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
resource "aws_vpc" "terraform" {
  cidr_block              =  ("192.168.0.0/16")
  enable_dns_hostnames    = true
  tags = {
    Name = "vpc-chiru"
  }
}
# External gateway configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    Name = "internet-gateway"
  }
}
#Subnet configuration
resource "aws_subnet" "public" {
  count = length(var.subnets_cidr)
  vpc_id     = aws_vpc.terraform.id
  cidr_block = element(var.subnets_cidr,count.index)
  tags = {
    Name = "subnet-${count.index+1}"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "RouteTable"
  }
}

# Route table associatiion with public subnets
resource "aws_route_table_association" "a" {
  count = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}


