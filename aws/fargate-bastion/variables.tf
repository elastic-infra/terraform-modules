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
  })
}

variable "timeout" {
  type        = number
  description = "ECS task timeout"
  default     = 60 * 60
}
