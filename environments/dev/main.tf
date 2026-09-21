data "terraform_remote_state" "bootstrap" {
  backend = "local"

  config = {
    path = "${path.module}/../../bootstrap/dev/terraform.tfstate"
  }
}

module "bastion" {
  source = "../../modules/bastion"

  name_prefix                 = "dev-bastion"
  vpc_id                      = data.terraform_remote_state.bootstrap.outputs.vpc_id
  subnet_id                   = data.terraform_remote_state.bootstrap.outputs.public_subnet_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  allowed_egress_cidr_blocks  = var.allowed_egress_cidr_blocks

  tags = {
    Environment = "dev"
  }
}
