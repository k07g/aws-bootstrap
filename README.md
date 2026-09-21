# aws-bootstrap
AWS環境の初期構築

## 構成

```
bootstrap/
  dev/            # dev用tfstate保存バケット作成用config(ローカルstate、dev AWSアカウント向け)
  prod/           # prod用tfstate保存バケット作成用config(ローカルstate、prod AWSアカウント向け)
environments/
  dev/            # dev環境用のroot module
modules/
  state-backend/  # tfstate保存用S3バケットモジュール
  network/        # VPC・パブリックサブネットモジュール
  bastion/        # 踏み台サーバ(EC2)モジュール
```

dev/prodはAWSアカウント自体を分ける想定のため、`bootstrap`・`environments`ともに環境ごとに
ディレクトリを分けています。認証はAWS CLIのプロファイル(`~/.aws/config`)で環境ごとに切り替える
想定で、各configの`aws_profile`変数(未指定時はデフォルトの認証情報チェーンを使用)で指定します。

## 0. アカウント基盤(tfstate用S3バケット・VPC)の作成(初回のみ)

`bootstrap/<env>` は、そのAWSアカウントの土台となる以下2つを作成します。

- `environments/*` がbackendとして使うtfstate保存用S3バケット(このバケット自体はS3
  backendに保存できない鶏卵問題があるため、`bootstrap/<env>`自体はローカルstateで管理)
- `environments/<env>` から共有して使うVPC・パブリックサブネット

```sh
cd bootstrap/dev
terraform init
terraform apply -var="aws_profile=dev"   # devアカウント用プロファイルを指定
```

prodアカウントの場合も同様に `bootstrap/prod` で実行します。

デフォルトのバケット名はdev: `k07g.terraform.dev` / prod: `k07g.terraform.prod` です。変更する
場合は各`bootstrap/<env>`の`state_bucket_name`変数を指定し、対応する
`environments/<env>/backend.tf`の`bucket`も合わせて変更してください。

`environments/<env>` は `terraform_remote_state`(local backend)で `bootstrap/<env>/terraform.tfstate`
を直接参照してVPC/サブネットIDを取得するため、`environments/<env>` を実行する前に
`bootstrap/<env>` を同じマシン上でapply済みにしておく必要があります。

## dev環境の踏み台サーバ構築

`bootstrap/dev` で作成したVPC・パブリックサブネット(IGW経由でインターネットに到達可能)の中に
踏み台サーバを構築します。踏み台サーバはSSM Session Manager経由でのみ接続する構成です
(SSHポート・インバウンドルールは一切開放しません)。

### 事前準備

- 上記の手順で `bootstrap/dev` をapply済みであること

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
