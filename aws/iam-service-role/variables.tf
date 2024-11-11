variable "trusted_services" {
  description = "AWS Services that can assume these roles"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "name" {
  description = "IAM role name"
  type        = string
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "role_inline_policies" {
  description = "List of name and IAM policy document to attach to IAM role"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "role_sts_externalid" {
  description = "STS ExternalId condition values to use with a role"
  type        = list(string)
  default     = []
}

variable "role_tags" {
  description = "Tags for IAM Role"
  type        = map(string)
  default     = {}
}
