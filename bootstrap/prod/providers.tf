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

locals {
  # prod_account_idが指定された場合、そのアカウントのOrganizationAccountAccessRoleを
  # assumeする(専用SSOアクセスを使わず管理アカウントの認証情報から直接操作する場合を想定)
  prod_assume_role_arn = var.prod_account_id != null ? "arn:aws:iam::${var.prod_account_id}:role/OrganizationAccountAccessRole" : null
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  dynamic "assume_role" {
    for_each = local.prod_assume_role_arn != null ? [local.prod_assume_role_arn] : []
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = {
      Project     = "aws-bootstrap"
      Environment = "prod"
      ManagedBy   = "terraform"
    }
  }
}
