output "role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of IAM role"
  value       = aws_iam_role.this.name
}

output "role_unique_id" {
  description = "The stable and unique string identifying the role"
  value       = aws_iam_role.this.unique_id
}

output "instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.arn, [""]), 0)
}

output "instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.name, [""]), 0)
}
