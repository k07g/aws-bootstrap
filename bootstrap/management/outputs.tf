output "workloads_ou_id" {
  description = "作成したWorkloads OUのID"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "prod_account_id" {
  description = "作成したprodアカウントのID"
  value       = aws_organizations_account.prod.id
}

output "prod_account_arn" {
  description = "作成したprodアカウントのARN"
  value       = aws_organizations_account.prod.arn
}
