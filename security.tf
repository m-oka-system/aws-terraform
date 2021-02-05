################################
# Security group
################################
module "http" {
  source      = "./security_group"
  name        = "tf_http_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https" {
  source      = "./security_group"
  name        = "tf_https_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect" {
  source      = "./security_group"
  name        = "tf_http_recirect_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

module "efs" {
  source      = "./security_group"
  name        = "tf_efs_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 2049
  cidr_blocks = [aws_vpc.vpc.cidr_block]
}

# MyIPを使う方法
# https://dev.classmethod.jp/articles/reference-my-pubic-ip-in-terraform/
data http ifconfig {
  url = "http://ipv4.icanhazip.com/"
}

locals {
  current-ip   = chomp(data.http.ifconfig.body)
  allowed-cidr = (var.allowed-cidr == null) ? "${local.current-ip}/32" : var.allowed-cidr
}

module "ssh" {
  source      = "./security_group"
  name        = "tf_ssh_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 22
  cidr_blocks = [local.allowed-cidr]
}

################################
# KMS
################################
resource "aws_kms_key" "customer_key" {
  description             = "Customer Master Key"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "customer_key_alias" {
  name          = "alias/customer_master_key"
  target_key_id = aws_kms_key.customer_key.id
}

################################
# SSM
################################
//resource "aws_ssm_parameter" "ecs_db_hostname" {
//  name        = "ecs_db_hostname"
//  type        = "String"
//  value       = "${var.db_identifier}.cekjx3vyluhs.ap-northeast-1.rds.amazonaws.com"
//  description = "データベースのホスト名"
//}
//
//resource "aws_ssm_parameter" "ecs_db_password" {
//  name        = "ecs_db_password"
//  type        = "SecureString"
//  value       = "uninitialized"
//  description = "データベースのパスワード"
//
//  lifecycle {
//    ignore_changes = [value]
//  }
//}

# Overwrite password with aws cli
# aws ssm put-parameter --name "ecs_db_password" --type SecureString --value "My5up3rStr0ngPaSw0rd!" --overwrite
