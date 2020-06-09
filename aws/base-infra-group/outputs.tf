output "iam_reader_group_name" {
  value       = aws_iam_group.iam_reader.name
  description = "Name of IAM reader group"
}

output "infra_system_group_name" {
  value       = aws_iam_group.infra_system.name
  description = "Name of system group"
}
