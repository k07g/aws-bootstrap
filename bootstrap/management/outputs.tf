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

output "dev_account_id" {
  description = "作成したdevアカウントのID"
  value       = aws_organizations_account.dev.id
}

output "dev_account_arn" {
  description = "作成したdevアカウントのARN"
  value       = aws_organizations_account.dev.arn
}

output "sandbox_ou_id" {
  description = "既存Sandbox OUのID"
  value       = aws_organizations_organizational_unit.sandbox.id
}

output "deployments_ou_id" {
  description = "既存Deployments OUのID"
  value       = aws_organizations_organizational_unit.deployments.id
}

output "sdlc_ou_id" {
  description = "既存SDLC OU(Deployments配下)のID"
  value       = aws_organizations_organizational_unit.sdlc.id
}
