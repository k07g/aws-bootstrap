variable "domain_name" {
  description = "作成するパブリックホストゾーンのドメイン名(例: example.com)"
  type        = string
}

variable "comment" {
  description = "ホストゾーンのコメント"
  type        = string
  default     = null
}

variable "tags" {
  description = "リソースに付与する追加タグ"
  type        = map(string)
  default     = {}
}
