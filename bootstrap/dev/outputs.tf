output "state_bucket_id" {
  description = "作成したTerraform state用S3バケット名"
  value       = module.state_backend.bucket_id
}

output "state_bucket_arn" {
  description = "作成したTerraform state用S3バケットのARN"
  value       = module.state_backend.bucket_arn
}

output "github_actions_role_arn" {
  description = "GitHub ActionsがOIDC経由でassumeするIAMロールのARN。GitHub側でリポジトリ変数 AWS_DEV_DEPLOY_ROLE_ARN に設定する"
  value       = module.github_actions_dev_deploy.role_arn
}
