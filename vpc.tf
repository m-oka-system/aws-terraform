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

resource "aws_subnet" "subnets" {
  count             = length(var.vpc.subnets)
  cidr_block        = values(var.vpc.subnets)[count.index].cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = values(var.vpc.subnets)[count.index].az
  tags = {
    Name = keys(var.vpc.subnets)[count.index]
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
