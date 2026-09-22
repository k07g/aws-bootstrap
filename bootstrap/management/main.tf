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
