variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

locals {
  cluster_name = "test-eks-${random_string.suffix.result}"
  common_prefix = "test"
  elk_domain = "${local.common_prefix}-elk-domain"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "test-vpc"
  cidr                 = "172.32.0.0/20"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.32.1.0/24", "172.32.2.0/24", "172.32.3.0/24"]
  public_subnets       = ["172.32.4.0/24", "172.32.5.0/24", "172.32.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
