terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # tfstate保存先バケット自体を作成するため、このconfigはローカルstateで管理する
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "aws-bootstrap"
      ManagedBy = "terraform"
    }
  }
}
