variable "system_group_name" {
  type        = string
  default     = "infra-system"
  description = "Name of system group"
}

variable "partition_ctl_s3_bucket" {
  type        = list(string)
  default     = []
  description = "S3 bucket list for partition-ctl"
}

variable "use_register_r53" {
  type        = bool
  default     = false
  description = "Whether register-r53 is used or not"
}
