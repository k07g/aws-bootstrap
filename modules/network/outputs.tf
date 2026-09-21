output "vpc_id" {
  description = "作成したVPCのID"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "作成したパブリックサブネットのID(キーはpublic_subnetsのキーに対応)"
  value       = { for k, s in aws_subnet.public : k => s.id }
}
