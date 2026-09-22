variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "新規作成するVPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "作成するパブリックサブネットのマップ(キーは任意の識別子)"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    a = { cidr_block = "10.0.1.0/24", availability_zone = "ap-northeast-1a" }
    c = { cidr_block = "10.0.2.0/24", availability_zone = "ap-northeast-1c" }
  }
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

variable "route53_subdomain_name" {
  description = "作成するRoute53パブリックホストゾーンのサブドメイン名"
  type        = string
  default     = "dev.ea-sys.jp"
}
