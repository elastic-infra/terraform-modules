variable "agent_space_name" {
  description = "Name of the AWS DevOps Agent Agent Space. Must be unique within the account/region."
  type        = string
}

variable "agent_space_description" {
  description = "Description of the Agent Space."
  type        = string
  default     = ""
}

variable "agent_space_role_name" {
  description = "IAM role name assumed by the Agent Space (aidevops.amazonaws.com). Defaults to DevOpsAgent-<agent_space_name>-Space."
  type        = string
  default     = null
}

variable "operator_role_name" {
  description = "IAM role name assumed by the Operator App. Defaults to DevOpsAgent-<agent_space_name>-WebappAdmin."
  type        = string
  default     = null
}

variable "agent_space_managed_policy_arns" {
  description = "AWS managed policy ARNs attached to the Agent Space role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AIDevOpsAgentAccessPolicy"]
}

variable "operator_managed_policy_arns" {
  description = "AWS managed policy ARNs attached to the Operator role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AIDevOpsOperatorAppAccessPolicy"]
}

variable "tags" {
  description = "Tags applied to the IAM roles created by this module."
  type        = map(string)
  default     = {}
}
