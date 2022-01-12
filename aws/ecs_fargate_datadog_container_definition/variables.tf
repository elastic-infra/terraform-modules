variable "container" {
  type = object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    port   = number
  })
  default = {
    name   = "datadog-agent"
    image  = "public.ecr.aws/datadog/agent:latest"
    cpu    = 10
    memory = 256
    port   = 8126
  }
  description = "Basic parameters of the DataDog container"
}

variable "docker_labels" {
  type        = map(string)
  default     = null
  description = "The configuration options to send to the docker_labels"
}

variable "log_configuration" {
  type = object({
    logDriver     = string
    secretOptions = any
    options       = map(any)
  })
  description = "Log configuration options to send to a custom log driver for the container"
}

variable "map_environments" {
  type        = map(string)
  description = "The environment variables to pass to the container. This is a map of string: {key: value}. map_environment overrides environment"
}

variable "map_secrets" {
  type        = map(string)
  description = "The secrets variables to pass to the container. This is a map of string: {key: value}. map_secrets overrides secrets"
}
