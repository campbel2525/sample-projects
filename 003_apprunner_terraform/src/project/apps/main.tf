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
    key = "apps/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------

module "private_subnet_1a" {
  source = "../../modules/get_subnet"

  subnet_name = "private-subnet-1a"
}

# module "private_subnet_1c" {
#   source = "../../modules/get_subnet"

#   subnet_name = "private-subnet-1c"
# }

module "app_sg" {
  source = "../../modules/get_security_group"

  vpc_name            = "vpc"
  security_group_name = "app-sg"
}

module "migration_sg" {
  source = "../../modules/get_security_group"

  vpc_name            = "vpc"
  security_group_name = "migration-sg"
}

module "rds" {
  source = "../../modules/get_rds"

  db_instance_identifier = "db1-mysql-standalone"
}

module "current_account" {
  source = "../../modules/get_aws_account"
}
