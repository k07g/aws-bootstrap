output "vpc_id" {
  description = "使用しているVPCのID(bootstrap/devで作成)"
  value       = data.terraform_remote_state.bootstrap.outputs.vpc_id
}

output "public_subnet_id" {
  description = "使用しているパブリックサブネットのID(bootstrap/devで作成)"
  value       = data.terraform_remote_state.bootstrap.outputs.public_subnet_id
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
