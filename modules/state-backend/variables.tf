variable "bucket_name" {
  description = "Terraform state保存用S3バケット名(グローバルで一意である必要がある)"
  type        = string
}

variable "tags" {
  description = "リソースに付与する追加タグ"
  type        = map(string)
  default     = {}
}
