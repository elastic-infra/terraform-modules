variable "cloudwatch_logs_retention_in_days" {
  type        = number
  default     = 90
  description = "The number of days you want to retain log events"
}

variable "container_environments" {
  type        = list
  description = "The environments to set to each ECS container"
}

variable "container_image_url" {
  type        = string
  description = "The URL of the image used to launch the container. Images in the Docker Hub registry available by default"
}

variable "container_secrets" {
  type        = list
  description = "The secrets to set to each ECS container"
}

variable "db_container_cpu" {
  type        = number
  default     = 512
  description = "The number of cpu units to reserve for the container which is used to kick the DB tasks"
}

variable "db_container_memory" {
  type        = number
  default     = 1024
  description = "The amount of memory (in MiB) to allow the container to use the DB tasks"
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "The ARN of ECS execution role"
}

variable "ecs_security_group_ids" {
  type        = list
  description = "The list of security group IDs to assign to the ECS task or service"
}

variable "ecs_subnet_ids" {
  type        = list
  description = "The list of subnet IDs to assign to the ECS task or service"
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "If true, Public IP is assigned to ECS service"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "The ARN of the ECS task role"
}

variable "lb_access_log_bucket" {
  type        = string
  default     = null
  description = "The S3 bucket name to store the logs in"
}

variable "lb_access_log_prefix" {
  type        = string
  default     = null
  description = "The prefix (logical hierarchy) in the access log bucket, the logs are placed the `LB_NAME/` if not configured"
}

variable "lb_certificate_arn" {
  type        = string
  description = "The ARN of the default SSL server certificate"
}

variable "lb_security_groups" {
  type        = list
  description = "The list of security group IDs to assign to the LB"
}

variable "lb_ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "The name of the SSL Policy for the listener"
}

variable "lb_subnets" {
  type        = list
  description = "The list of subnet IDs to attach to the LB"
}

variable "prefix" {
  type        = string
  description = "A prefix for the resource names"
  default     = null
}

variable "server_container_cpu" {
  type        = number
  default     = 1024
  description = "The number of cpu units to reserve for the server container"
}

variable "server_container_memory" {
  type        = number
  default     = 2048
  description = "The amount of memory (in MiB) to allow the server container"
}

variable "server_desired_count" {
  type        = number
  default     = 1
  description = "The number of redash server tasks"
}

variable "vpc_id" {
  type        = string
  description = "The ID of VPC where the load balancer is installed"
}

variable "worker_container_cpu" {
  type        = number
  default     = 1024
  description = "The number of cpu units to reserve for the worker container"
}

variable "worker_container_memory" {
  type        = number
  default     = 2048
  description = "The amount of memory (in MiB) to allow the worker container"
}

variable "worker_desired_count" {
  type        = number
  default     = 1
  description = "The number of redash worker tasks"
}
