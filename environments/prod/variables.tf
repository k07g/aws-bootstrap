variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "route53_domain_name" {
  description = "作成するRoute53パブリックホストゾーンのドメイン名"
  type        = string
  default     = "ea-sys.jp"
}
