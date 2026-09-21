output "state_bucket_id" {
  description = "作成したTerraform state用S3バケット名"
  value       = module.state_backend.bucket_id
}

output "state_bucket_arn" {
  description = "作成したTerraform state用S3バケットのARN"
  value       = module.state_backend.bucket_arn
}
