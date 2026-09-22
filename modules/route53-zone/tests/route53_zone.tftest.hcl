mock_provider "aws" {}

run "creates_zone_with_expected_domain_name" {
  command = plan

  variables {
    domain_name = "example.com"
  }

  assert {
    condition     = aws_route53_zone.this.name == "example.com"
    error_message = "Zone name should match the domain_name variable"
  }

  assert {
    condition     = aws_route53_zone.this.tags["Name"] == "example.com"
    error_message = "Name tag should default to the domain_name"
  }
}

run "applies_custom_comment_and_tags" {
  command = plan

  variables {
    domain_name = "example.com"
    comment     = "managed by terraform"
    tags = {
      Environment = "prod"
    }
  }

  assert {
    condition     = aws_route53_zone.this.comment == "managed by terraform"
    error_message = "Comment should match the comment variable"
  }

  assert {
    condition     = aws_route53_zone.this.tags["Environment"] == "prod"
    error_message = "Custom tags should be merged in"
  }
}
