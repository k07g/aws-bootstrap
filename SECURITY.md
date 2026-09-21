# Security Policy

## Reporting a Vulnerability

このリポジトリのTerraformコード・CI設定に関するセキュリティ上の問題(過剰な権限を持つ
IAMポリシー/セキュリティグループ、コミットされた認証情報、S3バケットの誤設定による
公開など)を発見した場合は、**公開のIssueを立てず**、以下のいずれかの方法で報告して
ください。

- [GitHub Security Advisories](https://github.com/k07g/aws-bootstrap/security/advisories/new)(推奨)
- リポジトリオーナー([@k07g](https://github.com/k07g))へのGitHub経由での直接連絡

再現手順・影響範囲・該当ファイルなど、可能な限り詳細な情報を含めてください。

## Scope

このリポジトリはAWS環境構築用のTerraformコード(tfstate用S3バケット、VPC、踏み台サーバ等)
を管理しています。アプリケーションコードは含みません。

## Response

個人で管理しているプロジェクトのため、対応時間の保証(SLA)はありませんが、報告を
受け次第できるだけ早く確認・対応します。
