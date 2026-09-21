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

variable "public_subnets" {
  description = "作成するパブリックサブネットのマップ(キーは任意の識別子。例: { a = { cidr_block = \"10.0.1.0/24\", availability_zone = \"ap-northeast-1a\" } })"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "tags" {
  description = "リソースに付与する追加タグ"
  type        = map(string)
  default     = {}
}
