output "role_arn" {
  description = "GitHub ActionsがassumeするIAMロールのARN"
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "GitHub Actions用OIDC providerのARN"
  value       = aws_iam_openid_connect_provider.github.arn
}
