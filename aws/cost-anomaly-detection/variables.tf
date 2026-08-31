variable "name" {
  type        = string
  description = "Base name used for the anomaly monitor and subscription"
}

variable "monitor_dimension" {
  type        = string
  description = "Cost dimension to monitor for anomalies. Allowed values: SERVICE, LINKED_ACCOUNT"
  default     = "SERVICE"

  validation {
    condition     = contains(["SERVICE", "LINKED_ACCOUNT"], var.monitor_dimension)
    error_message = "monitor_dimension must be either \"SERVICE\" or \"LINKED_ACCOUNT\"."
  }
}

variable "threshold" {
  type = object({
    absolute_usd = optional(number)
    percentage   = optional(number)
    combine_with = optional(string)
  })
  description = "Anomaly impact threshold settings. At least one of absolute_usd or percentage must be set; combine_with (AND or OR) is required when both are set"

  validation {
    condition     = var.threshold.absolute_usd != null || var.threshold.percentage != null
    error_message = "At least one of threshold.absolute_usd or threshold.percentage must be set."
  }

  validation {
    condition     = var.threshold.combine_with == null || contains(["AND", "OR"], var.threshold.combine_with)
    error_message = "threshold.combine_with must be either \"AND\" or \"OR\"."
  }

  validation {
    condition     = !(var.threshold.absolute_usd != null && var.threshold.percentage != null) || var.threshold.combine_with != null
    error_message = "threshold.combine_with must be set when both threshold.absolute_usd and threshold.percentage are specified."
  }
}

variable "sns" {
  type = object({
    topic_name        = string
    kms_master_key_id = optional(string, "alias/aws/sns")
  })
  description = "SNS topic settings for anomaly notifications."
}
