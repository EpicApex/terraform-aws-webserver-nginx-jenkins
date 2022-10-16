variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}
resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  SUFFIX = "${random_string.suffix.result}"
  cluster_name = "exercise-infra-eks-${local.SUFFIX}"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
  default_tags {
    tags = {
      SUFFIX_ID = "${local.SUFFIX}"
    }
  }
}
data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"
  name                 = "exercise-infra-eks-vpc"
  cidr                 = "10.210.0.0/24"
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  #azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.210.0.0/28", "10.210.0.16/28", "10.210.0.32/28"]
  public_subnets       = ["10.210.0.128/28", "10.210.0.144/28", "10.210.0.160/28"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_s3_endpoint = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    Environment = "Development"
    Region = "EU"
    Owner = "DevOps"
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