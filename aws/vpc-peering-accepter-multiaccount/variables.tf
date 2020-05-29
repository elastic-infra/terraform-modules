variable "enabled" {
  default     = "true"
  type        = string
  description = "Set to false to prevent the module from creating or accessing any resources"
}

variable "namespace" {
  description = "Namespace (e.g. `eg` or `cp`)"
  type        = string
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = string
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `a` or `b`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{\"BusinessUnit\" = \"XYZ\"`)"
}

variable "vpc_peering_id" {
  type        = string
  description = "VPC peering ID to be accepted"
}

variable "requester_vpc_cidr_blocks" {
  description = "CIDR blocks associated with the peer VPC (it should be fetched via VPC peering information but terraform-provider-aws does not read CidrBlockSet)"
  type        = list(string)
}

variable "accepter_region" {
  description = "Accepter AWS region"
  type        = string
}

variable "accepter_vpc_id" {
  description = "Accepter VPC ID filter"
  type        = string
  default     = ""
}

variable "accepter_vpc_tags" {
  type        = map(string)
  description = "Accepter VPC Tags filter"
  default     = {}
}
