mock_provider "aws" {}

override_data {
  target = data.aws_iam_policy_document.state
  values = {
    json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }]
    })
  }
}

variables {
  bucket_name = "example-terraform-state"
}

run "creates_bucket_with_expected_name" {
  command = plan

  assert {
    condition     = aws_s3_bucket.state.bucket == "example-terraform-state"
    error_message = "S3 bucket name should match the bucket_name variable"
  }
}

run "enables_versioning_and_encryption" {
  command = apply

  assert {
    condition     = aws_s3_bucket_versioning.state.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning should be enabled"
  }

  assert {
    condition     = one(one(aws_s3_bucket_server_side_encryption_configuration.state.rule).apply_server_side_encryption_by_default).sse_algorithm == "AES256"
    error_message = "Default encryption should be AES256"
  }
}

run "blocks_all_public_access" {
  command = apply

  assert {
    condition = alltrue([
      aws_s3_bucket_public_access_block.state.block_public_acls,
      aws_s3_bucket_public_access_block.state.block_public_policy,
      aws_s3_bucket_public_access_block.state.ignore_public_acls,
      aws_s3_bucket_public_access_block.state.restrict_public_buckets,
    ])
    error_message = "All public access block settings should be enabled"
  }
}
