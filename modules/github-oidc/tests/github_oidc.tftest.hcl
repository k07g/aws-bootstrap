mock_provider "aws" {}
mock_provider "tls" {}

override_data {
  target = data.tls_certificate.github
  values = {
    certificates = [
      {
        sha1_fingerprint = "0000000000000000000000000000000000000000"
      }
    ]
  }
}

override_data {
  target = data.aws_iam_policy_document.assume_role
  values = {
    json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Action    = "sts:AssumeRoleWithWebIdentity"
        Principal = { Federated = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
      }]
    })
  }
}

variables {
  role_name        = "test-github-actions-role"
  allowed_subjects = ["repo:k07g/aws-bootstrap:ref:refs/heads/main"]
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:DescribeInstances"
      Resource = "*"
    }]
  })
}

run "creates_oidc_provider_and_role" {
  command = plan

  assert {
    condition     = aws_iam_openid_connect_provider.github.url == "https://token.actions.githubusercontent.com"
    error_message = "OIDC provider URL should be GitHub's token issuer"
  }

  assert {
    condition     = contains(aws_iam_openid_connect_provider.github.client_id_list, "sts.amazonaws.com")
    error_message = "OIDC provider must allow the sts.amazonaws.com audience"
  }

  assert {
    condition     = aws_iam_role.github_actions.name == "test-github-actions-role"
    error_message = "IAM role name should match the role_name variable"
  }
}

run "attaches_the_provided_policy_as_is" {
  command = plan

  assert {
    condition     = aws_iam_role_policy.github_actions.policy == var.policy_json
    error_message = "The inline policy attached to the role should match policy_json exactly"
  }
}
