module "state_backend" {
  source = "../../modules/state-backend"

  bucket_name = var.state_bucket_name
}

module "network" {
  source = "../../modules/network"

  name_prefix        = "prod"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr

  tags = {
    Environment = "prod"
  }
}
