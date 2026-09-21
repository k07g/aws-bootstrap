variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "instance_type" {
  description = "踏み台サーバのEC2インスタンスタイプ"
  type        = string
  default     = "t3.micro"
}

variable "allowed_egress_cidr_blocks" {
  description = "アウトバウンド通信を許可するCIDRブロック(SSM経由の通信に必要)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
