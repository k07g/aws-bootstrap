mock_provider "aws" {}

override_data {
  target = data.aws_ssm_parameter.al2023_ami
  values = {
    value = "ami-0123456789abcdef0"
  }
}

override_data {
  target = data.aws_iam_policy_document.assume_role
  values = {
    json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = { Service = "ec2.amazonaws.com" }
      }]
    })
  }
}

variables {
  name_prefix = "test-bastion"
  vpc_id      = "vpc-0123456789abcdef0"
  subnet_id   = "subnet-0123456789abcdef0"
}

run "defaults_are_secure" {
  command = apply

  assert {
    condition     = aws_instance.bastion.instance_type == "t3.micro"
    error_message = "Default instance_type should be t3.micro"
  }

  assert {
    condition     = aws_instance.bastion.associate_public_ip_address == false
    error_message = "associate_public_ip_address should default to false"
  }

  assert {
    condition     = aws_instance.bastion.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 (http_tokens=required) should be enforced"
  }

  assert {
    condition     = aws_instance.bastion.root_block_device[0].encrypted == true
    error_message = "Root volume should be encrypted"
  }

  assert {
    condition     = length(aws_security_group.bastion.ingress) == 0
    error_message = "Bastion security group must have no ingress rules (SSM Session Manager only)"
  }
}

run "associates_public_ip_when_requested" {
  command = plan

  variables {
    associate_public_ip_address = true
  }

  assert {
    condition     = aws_instance.bastion.associate_public_ip_address == true
    error_message = "associate_public_ip_address should be true when requested"
  }
}

run "attaches_ssm_managed_instance_core_policy" {
  command = plan

  assert {
    condition     = aws_iam_role_policy_attachment.ssm_managed_instance_core.policy_arn == "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    error_message = "IAM role must have AmazonSSMManagedInstanceCore attached for SSM Session Manager access"
  }
}
