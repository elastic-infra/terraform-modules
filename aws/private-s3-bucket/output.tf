output "bucket_arn" {
  value       = aws_s3_bucket.b.arn
  description = "ARN of the S3 Bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.b.id
  description = "ID of the S3 Bucket"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.b.bucket_regional_domain_name
  description = "Region-specific domain name of the S3 Bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.b.bucket_domain_name
  description = "Domain name of the S3 Bucket"
}
