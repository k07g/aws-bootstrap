module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = var.state_bucket_name
}
