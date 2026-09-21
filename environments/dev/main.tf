module "bastion" {
  source = "../../modules/bastion"

  name_prefix                 = "dev-bastion"
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  allowed_egress_cidr_blocks  = var.allowed_egress_cidr_blocks

  tags = {
    Environment = "dev"
  }
}
