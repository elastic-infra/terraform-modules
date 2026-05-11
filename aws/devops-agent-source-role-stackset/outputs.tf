output "stack_set_name" {
  description = "Name of the CloudFormation StackSet that distributes AWSDevOpsAgentSourceRole."
  value       = aws_cloudformation_stack_set.source_role.name
}

output "stack_set_id" {
  description = "ID of the CloudFormation StackSet."
  value       = aws_cloudformation_stack_set.source_role.stack_set_id
}

output "role_name" {
  description = "IAM role name distributed to each workload account."
  value       = var.role_name
}
