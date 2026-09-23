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

variable "dev_subdomain_name_servers" {
  description = "environments/devが作成したdev.ea-sys.jpホストゾーンのネームサーバー(NS委任用)"
  type        = list(string)
  default = [
    "ns-1268.awsdns-30.org.",
    "ns-871.awsdns-44.net.",
    "ns-1852.awsdns-39.co.uk.",
    "ns-266.awsdns-33.com.",
  ]
}
