# aws-bootstrap
AWS環境の初期構築

## 構成

```
environments/
  dev/       # dev環境用のroot module
modules/
  bastion/   # 踏み台サーバ(EC2)モジュール
```

## dev環境の踏み台サーバ構築

踏み台サーバはSSM Session Manager経由でのみ接続する構成です(SSHポートは開放しません)。
接続するには、事前に対象VPC・サブネットが存在し、SSM APIへ到達できる経路(NAT Gateway、
インターネットゲートウェイ、またはVPCエンドポイント)が用意されている必要があります。

### 事前準備

- `environments/dev/backend.tf` の `bucket` を、既存のTerraform state用S3バケット名に置き換える
  (バージョニング有効化を推奨。ロックはTerraform 1.10+のS3ネイティブロック機能を使用するためDynamoDBは不要)
- `environments/dev/terraform.tfvars.example` を `terraform.tfvars` にコピーし、`vpc_id` / `subnet_id` を設定する

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
