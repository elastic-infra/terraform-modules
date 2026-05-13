resource "awscc_devopsagent_agent_space" "this" {
  name        = var.agent_space_name
  description = var.agent_space_description

  operator_app = {
    iam = {
      operator_app_role_arn = aws_iam_role.operator.arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachments_exclusive.agent_space_managed,
    aws_iam_role_policies_exclusive.agent_space_inline,
    aws_iam_role_policy_attachments_exclusive.operator_managed,
  ]
}

resource "awscc_devopsagent_association" "primary" {
  agent_space_id = awscc_devopsagent_agent_space.this.id
  service_id     = "aws"

  configuration = {
    aws = {
      assumable_role_arn = aws_iam_role.agent_space.arn
      account_id         = data.aws_caller_identity.current.account_id
      account_type       = "monitor"
    }
  }
}
