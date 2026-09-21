data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# SSM Session Manager経由でのみ接続するため、インバウンドルールは持たない
resource "aws_security_group" "bastion" {
  name_prefix = "${var.name_prefix}-"
  description = "Bastion host (SSM Session Manager only, no inbound rules)"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic for SSM Session Manager"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_egress_cidr_blocks
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "bastion" {
  name_prefix        = "${var.name_prefix}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  name_prefix = "${var.name_prefix}-"
  role        = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  associate_public_ip_address = var.associate_public_ip_address

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.tags, {
    Name = var.name_prefix
  })
}
