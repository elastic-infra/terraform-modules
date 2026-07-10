variable "oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider (Federated principal identifier)"
  type        = string
}

variable "github_repositories" {
  description = "StringLike condition values for token.actions.githubusercontent.com:sub (e.g. \"repo:org/repo:*\")"
  type        = list(string)
}

variable "oidc_audience" {
  description = "StringEquals condition values for token.actions.githubusercontent.com:aud"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
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

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "role_inline_policies" {
  description = "List of name and IAM policy document to attach to IAM role"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

variable "role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  description = "ARN of the policy to use for the permissions boundary of the role"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "Tags for IAM Role"
  type        = map(string)
  default     = {}
}
