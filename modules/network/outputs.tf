output "vpc_id" {
  description = "作成したVPCのID"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "作成したパブリックサブネットのID"
  value       = aws_subnet.public.id
}
