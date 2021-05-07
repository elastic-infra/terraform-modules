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

variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID filter"
  default     = ""
}

variable "requester_vpc_tags" {
  type        = map(string)
  description = "Requester VPC Tags filter"
  default     = {}
}

variable "peer_vpc_id" {
  description = "Peer VPC ID"
  type        = string
}

variable "peer_owner_id" {
  description = "Peer VPC owner's account ID"
  type        = string
}

variable "peer_region" {
  description = "Region where peer VPC resides"
  type        = string
}

variable "peer_vpc_cidr_blocks" {
  description = "CIDR blocks associated with the peer VPC"
  type        = list(string)
}

variable "peering_auto_accept" {
  type        = bool
  description = "Set true to enable auto-accept in an AWS account."
  default     = false
}
