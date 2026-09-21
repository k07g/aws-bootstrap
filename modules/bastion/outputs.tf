output "instance_id" {
  description = "踏み台サーバのインスタンスID"
  value       = aws_instance.bastion.id
}

output "private_ip" {
  description = "踏み台サーバのプライベートIPアドレス"
  value       = aws_instance.bastion.private_ip
}

output "security_group_id" {
  description = "踏み台サーバのセキュリティグループID"
  value       = aws_security_group.bastion.id
}

output "iam_role_arn" {
  description = "踏み台サーバに割り当てたIAMロールのARN"
  value       = aws_iam_role.bastion.arn
}
