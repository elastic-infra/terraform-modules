variable "organizational_unit_ids" {
  description = "OU IDs to deploy AWSDevOpsAgentSourceRole to. The StackSet auto-deploys to all accounts under these OUs."
  type        = list(string)
}

variable "monitoring_account_id" {
  description = "AWS DevOps Agent monitoring (admin) account id used in aws:SourceAccount trust condition. If null, the caller's account id is used."
  type        = string
  default     = null
}

variable "monitoring_region" {
  description = "Region where the Agent Space is deployed. Used in aws:SourceArn ArnLike trust condition."
  type        = string
  default     = "ap-northeast-1"
}

variable "stack_set_name" {
  description = "Name of the CloudFormation StackSet."
  type        = string
  default     = "AWSDevOpsAgentSourceRole"
}

variable "role_name" {
  description = "IAM role name created in each workload account."
  type        = string
  default     = "AWSDevOpsAgentSourceRole"
}

variable "managed_policy_name" {
  description = "AWS managed policy name attached to the role."
  type        = string
  default     = "AIDevOpsAgentAccessPolicy"
}

variable "regions" {
  description = "Regions in which StackSet instance metadata is recorded. The IAM role itself is global, so a single region is enough."
  type        = list(string)
  default     = ["ap-northeast-1"]
}

variable "tags" {
  description = "Tags applied to the StackSet resource."
  type        = map(string)
  default     = {}
}
