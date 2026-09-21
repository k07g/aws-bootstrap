variable "name_prefix" {
  description = "リソース名に使用するプレフィックス"
  type        = string
  default     = "network"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "パブリックサブネットのCIDRブロック"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "パブリックサブネットを配置するAZ(未指定の場合はリージョン内の最初のAZを自動選択)"
  type        = string
  default     = null
}

variable "tags" {
  description = "リソースに付与する追加タグ"
  type        = map(string)
  default     = {}
}
