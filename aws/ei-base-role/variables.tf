variable "prefix" {
  description = "Prefix for all resources"
  default     = "ei"
  type        = string
}

variable "additional_policy" {
  description = "Policy that merge into the base policy"
  default     = ""
  type        = string
}

variable "additional_policy_arns" {
  description = "List of ARNs of IAM policies to attach to base role"
  type        = list(string)
  default     = []
}
