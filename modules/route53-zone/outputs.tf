output "zone_id" {
  description = "作成したホストゾーンのID"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "ホストゾーンに割り当てられたネームサーバー(ドメインレジストラ側のNSレコード設定に使用)"
  value       = aws_route53_zone.this.name_servers
}
