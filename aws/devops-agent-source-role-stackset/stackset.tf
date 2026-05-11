data "aws_caller_identity" "current" {}

locals {
  effective_monitoring_account_id = coalesce(var.monitoring_account_id, data.aws_caller_identity.current.account_id)
}

resource "aws_cloudformation_stack_set" "source_role" {
  name             = var.stack_set_name
  description      = "Deploy AWSDevOpsAgentSourceRole to organization accounts"
  permission_model = "SERVICE_MANAGED"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  call_as          = "DELEGATED_ADMIN"

  template_body = file("${path.module}/templates/source-role.yaml")

  parameters = {
    MonitoringAccountId = local.effective_monitoring_account_id
    MonitoringRegion    = var.monitoring_region
    RoleName            = var.role_name
    ManagedPolicyName   = var.managed_policy_name
  }

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  managed_execution {
    active = true
  }

  tags = var.tags
}

resource "aws_cloudformation_stack_instances" "source_role" {
  stack_set_name = aws_cloudformation_stack_set.source_role.name
  call_as        = "DELEGATED_ADMIN"

  deployment_targets {
    organizational_unit_ids = var.organizational_unit_ids
  }

  regions = var.regions
}
