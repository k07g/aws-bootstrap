# NOTE: bucket は事前に作成済みの既存S3バケットに置き換えてください。
#       (バージョニング有効化を推奨)
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
