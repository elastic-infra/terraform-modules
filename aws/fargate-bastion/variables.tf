variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "ecs" {
  description = "Parameters of ECS bastion"
  type = object({
    cluster         = optional(string)
    subnets         = list(string)
    security_groups = list(string)
  })
}

variable "timeout" {
  type        = number
  description = "ECS task timeout"
  default     = 60 * 60
}
