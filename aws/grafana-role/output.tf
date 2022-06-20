output "role_arn" {
  value       = aws_iam_role.grafana.arn
  description = "Grafana monitoring role ARN"
}

output "role_name" {
  value       = aws_iam_role.grafana.name
  description = "Grafana monitoring role name"
}
