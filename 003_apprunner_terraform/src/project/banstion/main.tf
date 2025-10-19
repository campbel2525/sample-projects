# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_default_profile
}

# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
  }

  backend "s3" {
    key = "banstion/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
module "private_subnet_1a" {
  source = "../../modules/get_subnet"

  subnet_name = "private-subnet-1a"
}

module "ec2_sg" {
  source = "../../modules/get_security_group"

  vpc_name            = "vpc"
  security_group_name = "ec2-sg"
}

module "vpc" {
  source = "../../modules/get_vpc"

  vpc_name = "vpc"
}
