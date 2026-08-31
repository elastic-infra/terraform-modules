locals {
  threshold_dimensions = merge(
    var.threshold.absolute_usd != null ? { ANOMALY_TOTAL_IMPACT_ABSOLUTE = var.threshold.absolute_usd } : {},
    var.threshold.percentage != null ? { ANOMALY_TOTAL_IMPACT_PERCENTAGE = var.threshold.percentage } : {},
  )
  combine_thresholds = length(local.threshold_dimensions) > 1
}

resource "aws_ce_anomaly_monitor" "this" {
  name              = var.name
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = var.monitor_dimension
}

resource "aws_ce_anomaly_subscription" "this" {
  name = var.name
  # SNS subscribers only support IMMEDIATE; DAILY/WEEKLY are email-only.
  frequency = "IMMEDIATE"

  monitor_arn_list = [aws_ce_anomaly_monitor.this.arn]

  subscriber {
    type    = "SNS"
    address = aws_sns_topic.this.arn
  }

  threshold_expression {
    dynamic "dimension" {
      for_each = local.combine_thresholds ? {} : local.threshold_dimensions
      content {
        key           = dimension.key
        match_options = ["GREATER_THAN_OR_EQUAL"]
        values        = [tostring(dimension.value)]
      }
    }

    dynamic "and" {
      for_each = local.combine_thresholds && var.threshold.combine_with == "AND" ? local.threshold_dimensions : {}
      content {
        dimension {
          key           = and.key
          match_options = ["GREATER_THAN_OR_EQUAL"]
          values        = [tostring(and.value)]
        }
      }
    }

    dynamic "or" {
      for_each = local.combine_thresholds && var.threshold.combine_with == "OR" ? local.threshold_dimensions : {}
      content {
        dimension {
          key           = or.key
          match_options = ["GREATER_THAN_OR_EQUAL"]
          values        = [tostring(or.value)]
        }
      }
    }
  }

  depends_on = [aws_sns_topic_policy.this]
}
