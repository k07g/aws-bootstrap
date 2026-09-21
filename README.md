# aws-bootstrap
AWS環境の初期構築

## 構成

```
bootstrap/       # tfstate保存用S3バケット作成用config(ローカルstate)
environments/
  dev/            # dev環境用のroot module
modules/
  state-backend/  # tfstate保存用S3バケットモジュール
  network/        # VPC・パブリックサブネットモジュール
  bastion/        # 踏み台サーバ(EC2)モジュール
```

## 0. tfstate用S3バケットの作成(初回のみ)

`environments/*` はS3をbackendとして使用するため、先にバケットを作成しておく必要があります。
このバケット自体はS3 backendに保存できない(鶏卵問題)ため、`bootstrap/` はローカルstateで管理します。

```sh
cd bootstrap
terraform init
terraform apply
```

デフォルトのバケット名は `k07g.terraform.dev` です。変更する場合は `state_bucket_name` 変数を
指定し、`environments/dev/backend.tf` の `bucket` も合わせて変更してください。

## dev環境の踏み台サーバ構築

VPC・パブリックサブネット(IGW経由でインターネットに到達可能)を新規作成し、その中に
踏み台サーバを構築します。踏み台サーバはSSM Session Manager経由でのみ接続する構成です
(SSHポート・インバウンドルールは一切開放しません)。

### 事前準備

- 上記の手順でtfstate用S3バケットを作成済みであること
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
