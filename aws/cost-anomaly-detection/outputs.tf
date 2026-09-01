output "monitor_arn" {
  description = "ARN of the cost anomaly monitor"
  value       = aws_ce_anomaly_monitor.this.arn
}

output "subscription_arn" {
  description = "ARN of the cost anomaly subscription"
  value       = aws_ce_anomaly_subscription.this.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for anomaly notifications"
  value       = aws_sns_topic.this.arn
}
