terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
  }
}

# AWSアカウントIDを取得するためのデータソース
data "aws_caller_identity" "current" {
  # provider = aws.custom
}

data "aws_region" "current" {}
