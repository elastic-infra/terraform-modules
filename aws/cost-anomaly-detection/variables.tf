variable "sns" {
  type = object({
    topic_name        = string
    kms_master_key_id = optional(string, "alias/aws/sns")
  })
  description = "SNS topic settings for anomaly notifications."
}
