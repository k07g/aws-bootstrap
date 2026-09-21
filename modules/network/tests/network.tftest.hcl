mock_provider "aws" {}

run "creates_vpc_and_subnets_with_expected_cidr_and_az" {
  command = plan

  variables {
    name_prefix = "test"
    vpc_cidr    = "10.5.0.0/16"
    public_subnets = {
      a = { cidr_block = "10.5.1.0/24", availability_zone = "ap-northeast-1a" }
      c = { cidr_block = "10.5.2.0/24", availability_zone = "ap-northeast-1c" }
    }
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.5.0.0/16"
    error_message = "VPC CIDR did not match the vpc_cidr variable"
  }

  assert {
    condition     = aws_subnet.public["a"].cidr_block == "10.5.1.0/24"
    error_message = "Subnet 'a' CIDR did not match the public_subnets variable"
  }

  assert {
    condition     = aws_subnet.public["a"].availability_zone == "ap-northeast-1a"
    error_message = "Subnet 'a' availability_zone did not match the public_subnets variable"
  }

  assert {
    condition     = aws_subnet.public["c"].cidr_block == "10.5.2.0/24"
    error_message = "Subnet 'c' CIDR did not match the public_subnets variable"
  }

  assert {
    condition     = aws_subnet.public["c"].availability_zone == "ap-northeast-1c"
    error_message = "Subnet 'c' availability_zone did not match the public_subnets variable"
  }

  assert {
    condition     = alltrue([for s in aws_subnet.public : s.map_public_ip_on_launch])
    error_message = "All public subnets should auto-assign public IPs"
  }
}

run "creates_a_route_table_association_per_subnet" {
  command = plan

  variables {
    name_prefix = "test"
    vpc_cidr    = "10.5.0.0/16"
    public_subnets = {
      a = { cidr_block = "10.5.1.0/24", availability_zone = "ap-northeast-1a" }
      c = { cidr_block = "10.5.2.0/24", availability_zone = "ap-northeast-1c" }
    }
  }

  assert {
    condition     = length(aws_route_table_association.public) == 2
    error_message = "Should create one route table association per public subnet"
  }
}

run "applies_name_prefix_to_tags" {
  command = plan

  variables {
    name_prefix = "myenv"
    vpc_cidr    = "10.0.0.0/16"
    public_subnets = {
      a = { cidr_block = "10.0.1.0/24", availability_zone = "ap-northeast-1a" }
    }
  }

  assert {
    condition     = aws_vpc.this.tags["Name"] == "myenv-vpc"
    error_message = "VPC Name tag should be '<name_prefix>-vpc'"
  }

  assert {
    condition     = aws_subnet.public["a"].tags["Name"] == "myenv-public-a"
    error_message = "Subnet Name tag should be '<name_prefix>-public-<key>'"
  }
}
