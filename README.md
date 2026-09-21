# aws-bootstrap
AWS環境の初期構築

## 構成

```
bootstrap/
  dev/            # dev用tfstate保存バケット作成用config(ローカルstate、dev AWSアカウント向け)
  prod/           # prod用tfstate保存バケット作成用config(ローカルstate、prod AWSアカウント向け)
environments/
  dev/            # dev環境用のroot module(VPC・踏み台サーバを作成)
modules/
  state-backend/  # tfstate保存用S3バケットモジュール
  network/        # VPC・パブリックサブネットモジュール
  bastion/        # 踏み台サーバ(EC2)モジュール
```

dev/prodはAWSアカウント自体を分ける想定のため、`bootstrap`・`environments`ともに環境ごとに
ディレクトリを分けています。認証はAWS CLIのプロファイル(`~/.aws/config`)で環境ごとに切り替える
想定で、各configの`aws_profile`変数(未指定時はデフォルトの認証情報チェーンを使用)で指定します。

## 0. tfstate用S3バケットの作成(初回のみ)

`environments/*` はS3をbackendとして使用するため、先にバケットを作成しておく必要があります。
このバケット自体はS3 backendに保存できない(鶏卵問題)ため、`bootstrap/<env>` はローカルstateで
管理します。

```sh
cd bootstrap/dev
terraform init
terraform apply -var="aws_profile=dev"   # devアカウント用プロファイルを指定
```

prodアカウントの場合も同様に `bootstrap/prod` で実行します。

デフォルトのバケット名はdev: `k07g.terraform.dev` / prod: `k07g.terraform.prod` です。変更する
場合は各`bootstrap/<env>`の`state_bucket_name`変数を指定し、対応する
`environments/<env>/backend.tf`の`bucket`も合わせて変更してください。

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

## モジュールのテスト

`modules/*` には[terraform test](https://developer.hashicorp.com/terraform/language/tests)による
テスト(`tests/*.tftest.hcl`)を用意しています。`mock_provider`でAWS providerをモック化しているため、
AWS認証情報なし・実リソース作成なしで実行できます。PR作成時にもCIで自動実行されます。

```sh
cd modules/network   # または modules/bastion, modules/state-backend
terraform init
terraform test
```
