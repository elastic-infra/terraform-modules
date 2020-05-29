output "role_arn" {
  value       = aws_iam_role.rds_monitor_role.arn
  description = "RDS monitoring role ARN"
}

output "role_name" {
  value       = aws_iam_role.rds_monitor_role.name
  description = "RDS monitoring role name"
}
