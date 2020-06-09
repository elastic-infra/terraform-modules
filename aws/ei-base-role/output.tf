output "profile_name" {
  value       = aws_iam_instance_profile.ei_base.name
  description = "Name of Base instance profile"
}

output "policy_arn" {
  value       = aws_iam_policy.ei_base.arn
  description = "ARN of Base policy"
}
