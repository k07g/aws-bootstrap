module "route53_zone" {
  source = "../../modules/route53-zone"

  domain_name = var.route53_domain_name
  comment     = "Managed by aws-bootstrap (environments/prod)"

  tags = {
    Environment = "prod"
  }
}

# Google Workspace用メール関連レコード
resource "aws_route53_record" "mx" {
  zone_id = module.route53_zone.zone_id
  name    = var.route53_domain_name
  type    = "MX"
  ttl     = 300
  records = ["1 smtp.google.com."] # MXレコードは "優先度 ホスト名" の2フィールド形式が必須
}

resource "aws_route53_record" "txt" {
  zone_id = module.route53_zone.zone_id
  name    = var.route53_domain_name
  type    = "TXT"
  ttl     = 600
  records = [
    "asv_domain=e532222ea7c3b53d5d62cb82f367f897",
    "google-site-verification=z_y-W4h3BOkttfORGTxQuNim2ptUw4cY8Cic0ZnHeIA",
    "v=spf1 include:_spf.google.com ~all",
  ]
}

resource "aws_route53_record" "dmarc" {
  zone_id = module.route53_zone.zone_id
  name    = "_dmarc.${var.route53_domain_name}"
  type    = "TXT"
  ttl     = 600
  records = ["v=DMARC1; p=reject; rua=mailto:dmarc-reports@ea-sys.jp; pct=100; adkim=s; aspf=s"]
}
