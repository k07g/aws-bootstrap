module "route53_zone" {
  source = "../../modules/route53-zone"

  domain_name = var.route53_domain_name
  comment     = "Managed by aws-bootstrap (environments/prod)"

  tags = {
    Environment = "prod"
  }
}
