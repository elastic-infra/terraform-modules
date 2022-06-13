variable "prefix" {
  type        = string
  default     = "ei"
  description = "Prefix for all resources"
}

variable "assumerole_principals" {
  type        = list(string)
  default     = ["arn:aws:iam::089928438340:role/eicommonprod-grafana-ec2"]
  description = "List of principals to invoke assumerole"
}

variable "athena_workgroups" {
  type        = list(string)
  default     = []
  description = "List of WorkGroups"
}

variable "athena_result_bucket" {
  type        = string
  default     = null
  description = "Bucket of Athena's result"
}

variable "athena_search_buckets" {
  type        = list(string)
  default     = []
  description = "List of buckets searched by Athena"
}
