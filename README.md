# aws-bootstrap
AWS環境の初期構築

## 構成

```
environments/
  dev/       # dev環境用のroot module
modules/
  network/   # VPC・パブリックサブネットモジュール
  bastion/   # 踏み台サーバ(EC2)モジュール
```

## dev環境の踏み台サーバ構築

VPC・パブリックサブネット(IGW経由でインターネットに到達可能)を新規作成し、その中に
踏み台サーバを構築します。踏み台サーバはSSM Session Manager経由でのみ接続する構成です
(SSHポート・インバウンドルールは一切開放しません)。

### 事前準備

- `environments/dev/backend.tf` の `bucket` を、既存のTerraform state用S3バケット名に置き換える
  (バージョニング有効化を推奨。ロックはTerraform 1.10+のS3ネイティブロック機能を使用するためDynamoDBは不要)
- 必要に応じて `environments/dev/terraform.tfvars.example` を `terraform.tfvars` にコピーし、
  `vpc_cidr` / `public_subnet_cidr` を変更する(未指定時はデフォルト値を使用)

### 実行

```sh
cd environments/dev
terraform init
terraform plan
terraform apply
```

### 接続

```sh
aws ssm start-session --target $(terraform output -raw bastion_instance_id) --region ap-northeast-1
```
