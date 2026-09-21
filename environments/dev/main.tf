module "network" {
  source = "../../modules/network"

  name_prefix    = "dev"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets

  tags = {
    Environment = "dev"
  }
}

module "bastion" {
  source = "../../modules/bastion"

  name_prefix                 = "dev-bastion"
  vpc_id                      = module.network.vpc_id
  subnet_id                   = module.network.public_subnet_ids["a"]
  instance_type               = var.instance_type
  associate_public_ip_address = true
  allowed_egress_cidr_blocks  = var.allowed_egress_cidr_blocks

  tags = {
    Environment = "dev"
  }
}
