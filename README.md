# aws-bootstrap
AWS環境の初期構築

## 構成

```
bootstrap/
  management/     # AWS Organizations管理アカウント向けconfig(OU・アカウント作成、ローカルstate)
  dev/            # dev用tfstate保存バケット作成用config(ローカルstate、dev AWSアカウント向け)
  prod/           # prod用tfstate保存バケット作成用config(ローカルstate、prod AWSアカウント向け)
environments/
  dev/            # dev環境用のroot module(VPC・踏み台サーバを作成)
modules/
  state-backend/  # tfstate保存用S3バケットモジュール
  network/        # VPC・パブリックサブネットモジュール
  bastion/        # 踏み台サーバ(EC2)モジュール
  github-oidc/    # GitHub Actions用OIDC provider + IAMロールモジュール
```

dev/prodはAWSアカウント自体を分ける想定のため、`bootstrap`・`environments`ともに環境ごとに
ディレクトリを分けています。認証はAWS CLIのプロファイル(`~/.aws/config`)で環境ごとに切り替える
想定で、各configの`aws_profile`変数(未指定時はデフォルトの認証情報チェーンを使用)で指定します。

## -1. AWS Organizations管理アカウント: OU・アカウント作成(必要な場合のみ)

`bootstrap/management` は、AWS Organizationsの管理(root)アカウントに対して以下を作成します。

- `Workloads` OU(Root直下)
- その配下に新規AWSアカウント(デフォルト名`Prod`)

また、既存の組織構成のうち以下もコード化してimport済みです(実インフラと一致していることを
`terraform plan`で確認済み)。

- `Sandbox` OU と配下の`KorenagaMakoto`アカウント
- `Deployments` OU、その配下の`SDLC` OU と`TerraformDeploymentDevAccount`アカウント

Control Tower管理下と見られる`Security` OU(`Audit`/`Log Archive`アカウント)は、Control Tower
との競合を避けるため意図的にコード化・import対象外としています。

> **必ずAWSルートユーザーで手動実行すること。** `bootstrap/management`はCI/CD(GitHub Actions)
> からは一切実行しません。アカウント作成(`aws_organizations_account`)は管理アカウントの
> 強い権限を要する不可逆性の高い操作のため、常に人間がローカル環境から`terraform plan`の内容を
> 確認したうえで`terraform apply`してください。OIDC等による自動化の対象には含めないでください。

```sh
cd bootstrap/management
terraform init
terraform apply -var="aws_profile=<管理アカウント用プロファイル>" -var="prod_account_email=<一意なrootメール>"
```

認証には長期のrootアクセスキーではなく、`aws login`(AWS CLI v2.36+)によるコンソール
セッションベースの一時クレデンシャルを使うことを推奨します(`aws configure`等で長期の
rootアクセスキーを発行・保存しないでください)。

新規作成したアカウントへの`bootstrap/prod`等でのリソース作成は別途対応します(未着手)。

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

`bootstrap/dev`は、GitHub ActionsがOIDC経由でAWSにアクセスするためのIAMロール
(`modules/github-oidc`)も作成します。apply後、出力される`github_actions_role_arn`を
このリポジトリのGitHub Actions変数 `AWS_DEV_DEPLOY_ROLE_ARN`(Settings → Secrets and
variables → Actions → Variables)に設定してください。これによりCD(下記)が有効になります。

## CD(自動デプロイ)

mainブランチへのmerge後、CI(fmt/validate/test)が成功すると`environments/dev`が
`terraform apply`で自動デプロイされます(`.github/workflows/terraform-ci.yml`の
`deploy-dev` job)。認証はOIDCで発行される一時クレデンシャルを使用し、GitHub Secretsに
長期的なアクセスキーは保存しません。`bootstrap/*`および`environments/prod`はCD対象外で、
手動apply運用のままです。

## dev環境の踏み台サーバ構築

VPC・パブリックサブネット(IGW経由でインターネットに到達可能)を新規作成し、その中に
踏み台サーバを構築します。踏み台サーバはSSM Session Manager経由でのみ接続する構成です
(SSHポート・インバウンドルールは一切開放しません)。

### 事前準備

- 上記の手順でtfstate用S3バケットを作成済みであること
- 必要に応じて `environments/dev/terraform.tfvars.example` を `terraform.tfvars` にコピーし、
  `vpc_cidr` / `public_subnets` を変更する(未指定時はデフォルトで`ap-northeast-1a`/`1c`に
  それぞれパブリックサブネットを1つずつ作成する)

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
