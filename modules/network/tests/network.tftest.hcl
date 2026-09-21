mock_provider "aws" {}

override_data {
  target = data.aws_availability_zones.available
  values = {
    names = ["ap-northeast-1a", "ap-northeast-1c"]
  }
}

run "creates_vpc_and_subnet_with_expected_cidr" {
  command = plan

  variables {
    name_prefix        = "test"
    vpc_cidr           = "10.5.0.0/16"
    public_subnet_cidr = "10.5.1.0/24"
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.5.0.0/16"
    error_message = "VPC CIDR did not match the vpc_cidr variable"
  }

  assert {
    condition     = aws_subnet.public.cidr_block == "10.5.1.0/24"
    error_message = "Public subnet CIDR did not match the public_subnet_cidr variable"
  }

  assert {
    condition     = aws_subnet.public.map_public_ip_on_launch == true
    error_message = "Public subnet should auto-assign public IPs"
  }

  assert {
    condition     = aws_subnet.public.availability_zone == "ap-northeast-1a"
    error_message = "Public subnet should default to the first available AZ"
  }
}

run "uses_explicit_availability_zone_when_set" {
  command = plan

  variables {
    name_prefix        = "test"
    vpc_cidr           = "10.5.0.0/16"
    public_subnet_cidr = "10.5.1.0/24"
    availability_zone  = "ap-northeast-1c"
  }

  assert {
    condition     = aws_subnet.public.availability_zone == "ap-northeast-1c"
    error_message = "Public subnet should use the explicitly provided availability_zone"
  }
}

run "applies_name_prefix_to_tags" {
  command = plan

  variables {
    name_prefix        = "myenv"
    vpc_cidr           = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == "myenv-vpc"
    error_message = "VPC Name tag should be '<name_prefix>-vpc'"
  }

  assert {
    condition     = aws_subnet.public.tags["Name"] == "myenv-public"
    error_message = "Subnet Name tag should be '<name_prefix>-public'"
  }
}
