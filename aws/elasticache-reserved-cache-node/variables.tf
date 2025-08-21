variable "cache_node_type" {
  description = "Node type for the reserved cache node."
  type        = string
}

variable "duration" {
  description = "Duration of the reservation in RFC3339 duration format."
  type        = string
  default     = "P1Y"
}

variable "offering_type" {
  description = "Offering type of this reserved cache node."
  type        = string
  default     = "All Upfront"
}

variable "product_description" {
  description = "Engine type for the reserved cache node."
  type        = string
}

variable "cache_node_count" {
  description = "Number of cache node instances to reserve."
  type        = number
  default     = 1
}

variable "reservation_id" {
  description = "Customer-specified identifier to track this reservation."
  type        = string
  default     = null
}
