output "profile_name" {
  value       = aws_iam_instance_profile.ei_base.name
  description = "Name of Base instance profile"
}

output "policy_arn" {
  value       = aws_iam_policy.ei_base.arn
  description = "ARN of Base policy"
}

output "attached_policy_arns" {
  value = concat(
    [
      aws_iam_policy.ei_base.arn,
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    ],
    var.additional_policy_arns,
  )

  description = "List of ARNs for IAM policy attached to the base instance profile"
}
