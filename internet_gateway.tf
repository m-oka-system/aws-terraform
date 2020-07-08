################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}-igw"
  }
}

################################
# Public Route Table
################################
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc.name}-public-rt"
  }
}

resource "aws_route_table_association" "public-subnet-rta" {
  count          = length(var.vpc.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

################################
# Private Route Table
################################
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc.name}-private-rt"
  }
}

resource "aws_route_table_association" "private-subnet-rta" {
  count          = length(var.vpc.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}
