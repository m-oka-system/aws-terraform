################################
# VPC Endpoint
################################
data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name
}

//resource "aws_vpc_endpoint" "ec2" {
//  vpc_id            = aws_vpc.vpc.id
//  service_name      = "com.amazonaws.${local.region}.ec2"
//  vpc_endpoint_type = "Interface"
//  private_dns_enabled = true
//  subnet_ids = [aws_subnet.private_1a.id,aws_subnet.private_1c.id]
//
//  security_group_ids = [
//    module.privatelink_sg.security_group_id
//  ]
//
//  tags = {
//    Name = "TF_EC2_EP"
//  }
//
//}
//
//module "privatelink_sg" {
//  source      = "./security_group"
//  name        = "tf_privatelink_sg"
//  vpc_id      = aws_vpc.vpc.id
//  port        = 443
//  cidr_blocks = [aws_vpc.vpc.cidr_block]
//}
//
//resource "aws_vpc_endpoint" "s3" {
//  vpc_id          = aws_vpc.vpc.id
//  service_name    = "com.amazonaws.${local.region}.s3"
//  route_table_ids = [aws_route_table.private_1a.id, aws_route_table.private_1c.id]
//
//  tags = {
//    Name = "TF_S3_EP"
//  }
//}
