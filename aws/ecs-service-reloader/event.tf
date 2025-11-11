locals {
  targets = { for t in var.targets : "${t.cluster_name}-${t.service_name}" => t }
}

resource "aws_scheduler_schedule" "reload_ecs" {
  for_each = local.targets

  # NOTE: name_prefix must be between 1 and 38 characters
  name_prefix = substr("reload-${each.value.service_name}", 0, 37)
  description = format("cluster: %s, service: %s", each.value.cluster_name, each.value.service_name)
  group_name  = each.value.group_name
  state       = each.value.state

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = each.value.schedule
  schedule_expression_timezone = each.value.timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = module.scheduler_reload_ecs_role.role_arn

    input = jsonencode({
      Cluster            = each.value.cluster_name
      Service            = each.value.service_name
      ForceNewDeployment = true
    })

    retry_policy {
      maximum_retry_attempts = 1
    }
  }
}
