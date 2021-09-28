variable "region" {
  type        = string
  description = "AWS region of the VPC Endpoints"
  default     = "ap-northeast-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the VPC Endpoints are installed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The ID of one or more subnets in which to create a network interface for the endpoint"
}

variable "private_dns_enabled" {
  type        = bool
  description = "Whether or not to associate a private hosted zone with the specified VPC"
  default     = true
}
