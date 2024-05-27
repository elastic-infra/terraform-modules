output "infra_system_group_name" {
  value       = aws_iam_group.infra_system.name
  description = "Name of system group"
}
