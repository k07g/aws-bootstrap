data "aws_organizations_organization" "current" {}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = var.workloads_ou_name
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

# アカウント作成後、管理アカウントからは自動生成されるOrganizationAccountAccessRoleで
# アクセスできる。close_on_deletionは未指定(false)とし、誤ってterraform destroyしても
# アカウントが実際にクローズされないようにする。role_name/iam_user_access_to_billingは
# 作成時のみ有効な属性でAWS側から読み取れないため、ignore_changesで対象外にする
# (指定しないとterraform applyのたびに差分やリソース置き換えが計画される恐れがある)。
resource "aws_organizations_account" "prod" {
  name      = var.prod_account_name
  email     = var.prod_account_email
  parent_id = aws_organizations_organizational_unit.workloads.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name, iam_user_access_to_billing]
  }
}

resource "aws_organizations_account" "dev" {
  name      = var.dev_account_name
  email     = var.dev_account_email
  parent_id = aws_organizations_organizational_unit.workloads.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name, iam_user_access_to_billing]
  }
}

# --- 以下は既存のOrganizations構成をコード化してimportしたもの ---
# Control Tower管理下と見られる"Security" OU(Audit / Log Archiveアカウント)は
# 意図的に対象外としている(Control Towerとの競合を避けるため)。

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

resource "aws_organizations_organizational_unit" "deployments" {
  name      = "Deployments"
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

# Deployments OU配下にネストしたOU
resource "aws_organizations_organizational_unit" "sdlc" {
  name      = "SDLC"
  parent_id = aws_organizations_organizational_unit.deployments.id
}

resource "aws_organizations_account" "korenaga_makoto" {
  name      = "KorenagaMakoto"
  email     = "makoto+sb@ko07ga.jp"
  parent_id = aws_organizations_organizational_unit.sandbox.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name, iam_user_access_to_billing]
  }
}

resource "aws_organizations_account" "terraform_deployment_dev" {
  name      = "TerraformDeploymentDevAccount"
  email     = "makoto+terraformdeploymentdev@ko07ga.jp"
  parent_id = aws_organizations_organizational_unit.sdlc.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name, iam_user_access_to_billing]
  }
}

# --- IAM Identity Center: aws-adminユーザーのProdアカウントへのアクセス権 ---
# 既存アカウント(Sandbox/SDLC dev/管理アカウント)でaws-adminに付与されているのと同じ
# AWSAdministratorAccessパーミッションセットを、新規Prodアカウントにも付与する。

data "aws_ssoadmin_instances" "this" {}

data "aws_identitystore_user" "aws_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "aws-admin"
    }
  }
}

data "aws_ssoadmin_permission_set" "admin" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "AWSAdministratorAccess"
}

resource "aws_ssoadmin_account_assignment" "aws_admin_prod" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.admin.arn

  principal_id   = data.aws_identitystore_user.aws_admin.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.prod.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "aws_admin_dev" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.admin.arn

  principal_id   = data.aws_identitystore_user.aws_admin.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.dev.id
  target_type = "AWS_ACCOUNT"
}
