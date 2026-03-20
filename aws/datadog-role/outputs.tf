output "role_arn" {
  description = "ARN of Datadog IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of Datadog IAM role"
  value       = aws_iam_role.this.name
}
