variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "prod用AWSアカウントに対応するAWS CLIプロファイル名(~/.aws/configで設定)"
  type        = string
  default     = null
}

variable "state_bucket_name" {
  description = "Terraform state保存用S3バケット名(グローバルで一意である必要がある)"
  type        = string
  default     = "k07g.terraform.prod"
}

variable "prod_account_id" {
  description = "prod用AWSアカウントのID。指定した場合、そのアカウントのOrganizationAccountAccessRoleをassumeする(bootstrap/managementで作成したProdアカウント)"
  type        = string
  default     = "218733194573"
}
