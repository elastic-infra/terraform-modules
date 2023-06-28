output "arn" {
  description = "The ARN assigned by AWS for GitHub provider"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}
