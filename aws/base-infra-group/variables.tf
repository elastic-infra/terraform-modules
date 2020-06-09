variable "reader_group_name" {
  type        = string
  default     = "iam-reader"
  description = "Name of IAM reader group"
}

variable "system_group_name" {
  type        = string
  default     = "infra-system"
  description = "Name of system group"
}
