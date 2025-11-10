variable "infra_env" {
  type        = string
  description = "infra env"
}

variable "targets" {
  type = list(object({
    cluster_name = string
    service_name = string
    schedule     = string
    group_name   = optional(string, "default")
    timezone     = optional(string, "Asia/Tokyo")
    state        = optional(string, "ENABLED")
  }))
  description = "Target and schedule settings"
}
