variable "external_ids" {
  type        = list(string)
  description = "External IDs that Datadog uses for assuming the role"
}

variable "datadog_role_name" {
  type        = string
  description = "AWS IAM Role name for Datadog"
  default     = "DatadogIntegrationRole"
}

variable "custom_policy_name" {
  type        = string
  description = "Custom policy name that Datadog role uses"
  default     = "DatadogAWSIntegrationPolicy"
}

variable "full_permissions" {
  type        = bool
  description = "Grant full permissions for Datadog AWS integration. When false, only core metrics permissions are granted."
  default     = true
}

variable "cspm_permissions" {
  type        = bool
  description = "Attach SecurityAudit managed policy for Cloud Security Posture Management"
  default     = true
}

variable "additional_policy_arns" {
  type        = list(string)
  description = "Additional IAM managed policy ARNs to attach to Datadog role"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}

variable "datadog_aws_account_id" {
  type        = string
  description = "Datadog AWS account ID for trust policy"
  default     = "464622532012"
}
