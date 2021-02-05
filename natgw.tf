//################################
//# NATGW 1a
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
//resource "aws_route" "private_1a" {
//  route_table_id         = aws_route_table.private_1a.id
//  nat_gateway_id         = aws_nat_gateway.natgw_1a.id
//  destination_cidr_block = "0.0.0.0/0"
//}
//
//resource "aws_eip" "natgw_1a" {
//  vpc        = true
//  depends_on = [aws_internet_gateway.igw]
//
//  tags = {
//    Name = "${var.vpc_name}_natgw_1a_eip"
//  }
//}
//
//################################
//# NATGW 1c
//################################
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
//resource "aws_route" "private_1c" {
//  route_table_id         = aws_route_table.private_1c.id
//  nat_gateway_id         = aws_nat_gateway.natgw_1c.id
//  destination_cidr_block = "0.0.0.0/0"
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
