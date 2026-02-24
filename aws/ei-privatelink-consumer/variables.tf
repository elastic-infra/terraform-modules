variable "vpc_id" {
  type        = string
  description = "VPC ID where the VPC Endpoints are installed"
}

variable "service_region" {
  type        = string
  description = "Region where the endpoint service is hosted. If null, uses current region (same-region access)."
  default     = null
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

variable "ei_sg_ids" {
  type        = list(string)
  description = "Security Group IDs of EI Management Environment"
  default     = ["089928438340/sg-3845ff5c"]
}

variable "ei_cidrs" {
  type        = list(string)
  description = "CIDR blocks of EI Management Environment"
  default     = ["10.254.0.0/23"]
}
