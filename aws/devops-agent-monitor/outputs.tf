output "agent_space_id" {
  description = "ID of the created Agent Space."
  value       = awscc_devopsagent_agent_space.this.id
}

output "agent_space_arn" {
  description = "ARN of the created Agent Space."
  value       = awscc_devopsagent_agent_space.this.arn
}

output "agent_space_name" {
  description = "Name of the created Agent Space."
  value       = awscc_devopsagent_agent_space.this.name
}

output "agent_space_role_arn" {
  description = "ARN of the IAM role assumed by the Agent Space (primary monitor association uses this)."
  value       = aws_iam_role.agent_space.arn
}

output "operator_role_arn" {
  description = "ARN of the IAM role assumed by the Operator App."
  value       = aws_iam_role.operator.arn
}
