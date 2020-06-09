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
