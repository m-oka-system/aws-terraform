# Common
variable "region" {
  default = "ap-northeast-1"
}

variable "zones" {
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
  ]
}

# VPC
variable "vpc" {
  default = {
    name = "vpc"
    cidr = "10.0.0.0/16"
    subnets = {
      public_subnet-1a = {
        az   = "ap-northeast-1a"
        cidr = "10.0.11.0/24"
      }
      public_subnet-1c = {
        az   = "ap-northeast-1c"
        cidr = "10.0.12.0/24"
      }
      private_subnet-1a = {
        az   = "ap-northeast-1a"
        cidr = "10.0.21.0/24"
      }
      private_subnet-1c = {
        az   = "ap-northeast-1c"
        cidr = "10.0.22.0/24"
      }
    }
  }
}

