resource "aws_vpc" "vpc_eks_learn" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "eks_pubsubnet" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.vpc_eks_learn.id
  cidr_block = element(var.public_subnets,count.index)
  availability_zone = element(var.availability_zone,count.index)
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "${var.vpc_name}_${count.index + 1}"
  }
}

resource "aws_subnet" "eks_privsubnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.vpc_eks_learn.id
  cidr_block = element(var.private_subnets,count.index)
  availability_zone = element(var.availability_zone,count.index)
  tags = {
    "Name" = "${var.vpc_name}_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "EKS_gateway" {
    vpc_id = aws_vpc.vpc_eks_learn.id
    tags={
        Name=var.igw_name
    } 
}

resource "aws_route_table" "EKS_route_table" {
  vpc_id = aws_vpc.vpc_eks_learn.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EKS_gateway.id
  }
  tags = {
    Name = "anuvind_${var.vpc_name}_ROUTE_TABLE"
  }
}

resource "aws_route_table_association" "EKS_ASSO" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.eks_pubsubnet[*].id,count.index)
  route_table_id = aws_route_table.EKS_route_table.id
}
resource "aws_security_group" "nat_instance_sg" {
  name        = "anuvind_nat-instance-sg"
  description = "Security group for NAT instance"   
  vpc_id = aws_vpc.vpc_eks_learn.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_network_interface" "public_instance_network_interface" {
  subnet_id      = aws_subnet.eks_pubsubnet[0].id
  source_dest_check = false
  security_groups = [aws_security_group.nat_instance_sg.id]
}
 
resource "aws_route_table" "EKS_route_table_private" {
  vpc_id = aws_vpc.vpc_eks_learn.id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_network_interface.public_instance_network_interface.id
  }

  tags = {
    Name = "anuvind_PRIVATE_${var.vpc_name}_ROUTE_TABLE"
  }
}

resource "aws_route_table_association" "EKS_ASSO_private" {
  count = length(var.private_subnets)
  subnet_id      = element(aws_subnet.eks_privsubnet[*].id,count.index)
  route_table_id = aws_route_table.EKS_route_table_private.id
}
