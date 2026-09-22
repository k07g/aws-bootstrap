variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS Organizations管理アカウントに対応するAWS CLIプロファイル名(~/.aws/configで設定)"
  type        = string
  default     = null
}

variable "workloads_ou_name" {
  description = "ワークロード用アカウントを配置するOrganizational Unit名"
  type        = string
  default     = "Workloads"
}

variable "prod_account_name" {
  description = "作成するprodアカウントの表示名"
  type        = string
  default     = "Prod"
}

variable "prod_account_email" {
  description = "作成するprodアカウントのrootメールアドレス(AWS全体で一意である必要がある)"
  type        = string
}

variable "dev_account_name" {
  description = "作成するdevアカウントの表示名"
  type        = string
  default     = "Dev"
}

variable "dev_account_email" {
  description = "作成するdevアカウントのrootメールアドレス(AWS全体で一意である必要がある)"
  type        = string
}
