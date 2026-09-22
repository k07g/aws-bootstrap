output "state_bucket_id" {
  description = "作成したTerraform state用S3バケット名"
  value       = module.state_backend.bucket_id
}

output "state_bucket_arn" {
  description = "作成したTerraform state用S3バケットのARN"
  value       = module.state_backend.bucket_arn
}

output "route53_zone_id" {
  description = "作成したRoute53ホストゾーンのID"
  value       = module.route53_zone.zone_id
}

output "route53_name_servers" {
  description = "ドメインレジストラ側のNSレコードに設定するネームサーバー"
  value       = module.route53_zone.name_servers
}
