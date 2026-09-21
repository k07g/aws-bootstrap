variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_id" {
  description = "踏み台サーバを配置する既存VPCのID"
  type        = string
}

variable "subnet_id" {
  description = "踏み台サーバを配置する既存サブネットのID"
  type        = string
}

variable "instance_type" {
  description = "踏み台サーバのEC2インスタンスタイプ"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  description = "パブリックIPアドレスを割り当てるかどうか(パブリックサブネットに配置する場合などtrue)"
  type        = bool
  default     = false
}

variable "allowed_egress_cidr_blocks" {
  description = "アウトバウンド通信を許可するCIDRブロック(SSM経由の通信に必要)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
