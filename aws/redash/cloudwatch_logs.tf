resource "aws_cloudwatch_log_group" "logs" {
  for_each = local.container_names

  name              = each.value
  retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = var.tags
}
