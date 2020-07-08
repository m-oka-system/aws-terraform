################################
# VPC
################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc.name
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.vpc.public_subnets)
  cidr_block        = values(var.vpc.public_subnets)[count.index].cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = values(var.vpc.public_subnets)[count.index].az

  tags = {
    Name = keys(var.vpc.public_subnets)[count.index]
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.vpc.private_subnets)
  cidr_block        = values(var.vpc.private_subnets)[count.index].cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = values(var.vpc.private_subnets)[count.index].az

  tags = {
    Name = keys(var.vpc.private_subnets)[count.index]
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
