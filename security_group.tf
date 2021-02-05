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
