module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = var.state_bucket_name
}

data "aws_caller_identity" "current" {}

# environments/devをterraform applyするために必要な最小限の権限。
# EC2の作成系API(CreateVpc/CreateSubnet等)はAWS側の制約でresource ARNを指定できないため
# Resource "*" とする(このアカウントは他プロジェクトのリソースも同居しているため、将来的に
# アカウント分離やタグ条件によるスコープ強化を検討すること)。
data "aws_iam_policy_document" "github_actions_dev_deploy" {
  statement {
    sid       = "EC2Manage"
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    sid = "IAMForBastion"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:UntagInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dev-bastion-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/dev-bastion-*",
    ]
  }

  statement {
    sid       = "SSMReadAmiParameter"
    actions   = ["ssm:GetParameter", "ssm:GetParameters"]
    resources = ["arn:aws:ssm:*::parameter/aws/service/ami-amazon-linux-latest/*"]
  }

  statement {
    sid       = "TerraformStateObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${module.state_backend.bucket_arn}/dev/*"]
  }

  statement {
    sid       = "TerraformStateBucketList"
    actions   = ["s3:ListBucket"]
    resources = [module.state_backend.bucket_arn]
  }
}

module "github_actions_dev_deploy" {
  source = "../../modules/github-oidc"

  role_name = "github-actions-dev-deploy"
  # deploy-dev jobはGitHub Environment "dev"を指定しているため、OIDCトークンのsubクレームは
  # ref:refs/heads/main ではなく repo:<owner>@<owner_id>/<repo>@<repo_id>:environment:dev 形式になる。
  # owner/repoの数値IDは安定だがリポジトリ名で読みやすくするためワイルドカードでマッチさせる。
  allowed_subjects = ["repo:k07g@*/aws-bootstrap@*:environment:dev"]
  policy_json      = data.aws_iam_policy_document.github_actions_dev_deploy.json

  tags = {
    Environment = "dev"
  }
}
