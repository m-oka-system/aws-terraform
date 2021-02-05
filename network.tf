################################
# VPC
################################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_1a" {
  cidr_block              = "10.0.11.0/24"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_public_1a"
  }
}

resource "aws_subnet" "public_1c" {
  cidr_block              = "10.0.12.0/24"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_public_1c"
  }
}

resource "aws_subnet" "private_1a" {
  cidr_block              = "10.0.21.0/24"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}_private_1a"
  }
}

resource "aws_subnet" "private_1c" {
  cidr_block              = "10.0.22.0/24"
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}_private_1c"
  }
}

################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

################################
# Public Route Table
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_public_rt"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

################################
# Private Route Table
################################
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_private_1a_rt"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_private_1c_rt"
  }
}

//resource "aws_route" "private_1a" {
//  route_table_id         = aws_route_table.private_1a.id
//  nat_gateway_id         = aws_nat_gateway.natgw_1a.id
//  destination_cidr_block = "0.0.0.0/0"
//}
//
//resource "aws_route" "private_1c" {
//  route_table_id         = aws_route_table.private_1c.id
//  nat_gateway_id         = aws_nat_gateway.natgw_1c.id
//  destination_cidr_block = "0.0.0.0/0"
//}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

################################
# Network ACL
################################
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]

  tags = {
    Name = "${var.vpc_name}_public_acl"
  }

  egress {
    rule_no    = 100
    protocol   = -1
    from_port  = 0
    to_port    = 0
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    rule_no    = 100
    protocol   = -1
    from_port  = 0
    to_port    = 0
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]

  tags = {
    Name = "${var.vpc_name}_private_acl"
  }

  egress {
    rule_no    = 100
    protocol   = -1
    from_port  = 0
    to_port    = 0
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    rule_no    = 100
    protocol   = -1
    from_port  = 0
    to_port    = 0
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }
}

//################################
//# NATGW
//################################
//resource "aws_nat_gateway" "natgw_1a" {
//  allocation_id = aws_eip.natgw_1a.id
//  subnet_id     = aws_subnet.public_1a.id
//  depends_on    = [aws_internet_gateway.igw]
//
//  tags = {
//    Name = "${var.vpc_name}_natgw_1a"
//  }
//}
//
//resource "aws_nat_gateway" "natgw_1c" {
//  allocation_id = aws_eip.natgw_1c.id
//  subnet_id     = aws_subnet.public_1c.id
//  depends_on    = [aws_internet_gateway.igw]
//
//  tags = {
//    Name = "${var.vpc_name}_natgw_1c"
//  }
//}
//
//################################
//# EIP for NATGW
//################################
//resource "aws_eip" "natgw_1a" {
//  vpc        = true
//  depends_on = [aws_internet_gateway.igw]
//
//  tags = {
//    Name = "${var.vpc_name}_natgw_1a_eip"
//  }
//}
//
//resource "aws_eip" "natgw_1c" {
//  vpc        = true
//  depends_on = [aws_internet_gateway.igw]
//
//  tags = {
//    Name = "${var.vpc_name}_natgw_1c_eip"
//  }
//}

