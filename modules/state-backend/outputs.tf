output "bucket_id" {
  description = "作成したS3バケット名"
  value       = aws_s3_bucket.state.id
}

output "bucket_arn" {
  description = "作成したS3バケットのARN"
  value       = aws_s3_bucket.state.arn
}
