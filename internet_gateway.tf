################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}_igw"
  }
}

################################
# Public Route Table
################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc.name}_public_rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.vpc.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

################################
# Private Route Table
################################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}_private_rt"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = length(var.vpc.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
