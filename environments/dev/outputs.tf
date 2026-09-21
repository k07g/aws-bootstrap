output "vpc_id" {
  description = "作成したVPCのID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "作成したパブリックサブネットのID一覧(キーはpublic_subnetsのキーに対応)"
  value       = module.network.public_subnet_ids
}

output "bastion_instance_id" {
  description = "踏み台サーバのインスタンスID"
  value       = module.bastion.instance_id
}

output "bastion_private_ip" {
  description = "踏み台サーバのプライベートIPアドレス"
  value       = module.bastion.private_ip
}

output "ssm_connect_command" {
  description = "SSM Session Managerで接続するためのAWS CLIコマンド"
  value       = "aws ssm start-session --target ${module.bastion.instance_id} --region ${var.aws_region}"
}
