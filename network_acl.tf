################################
# Network ACL for Public Subnet
################################
resource "aws_network_acl" "public_subnet_acl" {
  count      = length(var.vpc.public_subnets)
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [element(aws_subnet.public_subnets.*.id, count.index)]

  tags = {
    Name = "${keys(var.vpc.public_subnets)[count.index]}_acl"
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
################################
# Network ACL for Private Subnet
################################
resource "aws_network_acl" "private_subnet_acl" {
  count      = length(var.vpc.private_subnets)
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [element(aws_subnet.private_subnets.*.id, count.index)]

  tags = {
    Name = "${keys(var.vpc.private_subnets)[count.index]}_acl"
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

