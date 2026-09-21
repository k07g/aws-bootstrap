terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.65"
    }
  }

  # tfstate保存先バケット自体を作成するため、このconfigはローカルstateで管理する
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "aws-bootstrap"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}
