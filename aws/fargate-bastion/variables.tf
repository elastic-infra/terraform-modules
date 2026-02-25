variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "ecs" {
  description = "Parameters of ECS bastion"
  type = object({
    cluster            = optional(string)
    subnets            = list(string)
    security_groups    = list(string)
    container_insights = optional(bool, false)
    log_configuration = optional(object({
      logDriver = string
      options   = map(string)
      secretOptions = optional(list(object({
        name      = string
        valueFrom = string
      })))
    }))
    log_configuration_timer = optional(object({
      logDriver = string
      options   = map(string)
      secretOptions = optional(list(object({
        name      = string
        valueFrom = string
      })))
    }))
  })
}

variable "timeout" {
  type        = number
  description = "ECS task timeout"
  default     = 60 * 60
}

variable "cpu_architecture" {
  type        = string
  description = "CPU architecture for ECS task (X86_64 or ARM64)"
  default     = "X86_64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "cpu_architecture must be X86_64 or ARM64."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}
