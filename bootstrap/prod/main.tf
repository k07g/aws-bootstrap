module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = var.state_bucket_name
}

module "route53_zone" {
  source = "../../modules/route53-zone"

  domain_name = var.route53_domain_name
  comment     = "Managed by aws-bootstrap (bootstrap/prod)"

  tags = {
    Environment = "prod"
  }
}
