provider "aws" {
  version = "~>3.0"
  region = "us-east-1"
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpccidr
}
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnetcidr
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table" "routtable" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table_association" "asso" {
  route_table_id = aws_route_table.routtable.id
  subnet_id = aws_subnet.subnet.id
}
resource "aws_route" "route" {
  route_table_id = aws_route_table.routtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.instance-type
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.sg.id]
  user_data = file("website.sh")
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.ec2name
  }
}
output "ec2-pub-ip" {
  value = aws_instance.ec2.public_ip
}