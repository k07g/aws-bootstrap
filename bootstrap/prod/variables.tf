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

variable "vpc_cidr" {
  description = "prod環境用VPCのCIDRブロック"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "prod環境用パブリックサブネットのCIDRブロック"
  type        = string
  default     = "10.1.1.0/24"
}
