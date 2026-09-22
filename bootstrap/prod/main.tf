module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = var.state_bucket_name
}

# environments/prodをterraform applyするために必要な最小限の権限。
data "aws_iam_policy_document" "github_actions_prod_deploy" {
  statement {
    sid       = "Route53Manage"
    actions   = ["route53:*"]
    resources = ["*"]
  }

  statement {
    sid       = "TerraformStateObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${module.state_backend.bucket_arn}/prod/*"]
  }

  statement {
    sid       = "TerraformStateBucketList"
    actions   = ["s3:ListBucket"]
    resources = [module.state_backend.bucket_arn]
  }
}

module "github_actions_prod_deploy" {
  source = "../../modules/github-oidc"

  role_name = "github-actions-prod-deploy"
  # deploy-prod jobはGitHub Environment "prod"を指定しているため、OIDCトークンのsubクレームは
  # repo:<owner>@<owner_id>/<repo>@<repo_id>:environment:prod 形式になる。
  allowed_subjects = ["repo:k07g@*/aws-bootstrap@*:environment:prod"]
  policy_json      = data.aws_iam_policy_document.github_actions_prod_deploy.json

  tags = {
    Environment = "prod"
  }
}
