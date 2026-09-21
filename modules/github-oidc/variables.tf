variable "role_name" {
  description = "GitHub ActionsがOIDC経由でassumeするIAMロール名"
  type        = string
}

variable "allowed_subjects" {
  description = "assumeを許可するOIDCトークンのsubクレーム(例: repo:owner/repo:ref:refs/heads/main)"
  type        = list(string)
}

variable "policy_json" {
  description = "ロールにアタッチするIAMポリシー(JSON)"
  type        = string
}

variable "tags" {
  description = "リソースに付与する追加タグ"
  type        = map(string)
  default     = {}
}
