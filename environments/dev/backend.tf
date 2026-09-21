# bucket は bootstrap/ (modules/state-backend) で作成したS3バケットを指定する。
# 先に bootstrap/ を apply してバケットを作成してから、このconfigを init/apply すること。
# Terraform 1.10+ のS3ネイティブロック機能を使用するため、DynamoDBテーブルは不要です。
terraform {
  backend "s3" {
    bucket       = "k07g.terraform.dev"
    key          = "dev/bastion/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
