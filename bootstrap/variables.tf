variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "state_bucket_name" {
  description = "Terraform state保存用S3バケット名(グローバルで一意である必要がある)"
  type        = string
  default     = "k07g.terraform.dev"
}
