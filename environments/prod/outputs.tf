output "route53_zone_id" {
  description = "作成したRoute53ホストゾーンのID"
  value       = module.route53_zone.zone_id
}

output "route53_name_servers" {
  description = "ドメインレジストラ側のNSレコードに設定するネームサーバー"
  value       = module.route53_zone.name_servers
}
