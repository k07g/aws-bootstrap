data "aws_organizations_organization" "current" {}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = var.workloads_ou_name
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

# アカウント作成後、管理アカウントからは自動生成されるOrganizationAccountAccessRoleで
# アクセスできる。close_on_deletionは未指定(false)とし、誤ってterraform destroyしても
# アカウントが実際にクローズされないようにする。
resource "aws_organizations_account" "prod" {
  name      = var.prod_account_name
  email     = var.prod_account_email
  parent_id = aws_organizations_organizational_unit.workloads.id

  lifecycle {
    prevent_destroy = true
  }
}
