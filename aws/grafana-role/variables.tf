variable "prefix" {
  type        = string
  default     = "ei"
  description = "Prefix for all resources"
}

variable "assumerole_principals" {
  type        = list(string)
  default     = ["arn:aws:iam::089928438340:role/eicommonprod-grafana-ec2"]
  description = "ARN list of principals to invoke assumerole"
}

variable "athena_workgroups" {
  type        = list(string)
  default     = []
  description = "ARN list of WorkGroups"
}

variable "athena_result_bucket" {
  type        = string
  default     = null
  description = "Bucket ARN of Athena's result"
}

variable "athena_search_buckets" {
  type        = list(string)
  default     = []
  description = "ARN list of buckets searched by Athena"
}

variable "cwlogs_search_loggroups" {
  type        = list(string)
  default     = []
  description = "ARN list of LogGroups searched by CloudWatch Logs Insight"
}
