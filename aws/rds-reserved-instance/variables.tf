variable "db_instance_class" {
  description = "DB instance class for the reserved DB instance."
  type        = string
}

variable "duration" {
  description = "Duration of the reservation in years or seconds."
  type        = number
  default     = 1
}

variable "multi_az" {
  description = "Whether the reservation applies to Multi-AZ deployments."
  type        = bool
  default     = false
}

variable "offering_type" {
  description = "Offering type of this reserved DB instance."
  type        = string
  default     = "All Upfront"
}

variable "product_description" {
  description = "Description of the reserved DB instance."
  type        = string
}

variable "instance_count" {
  description = "Number of instances to reserve."
  type        = number
}

variable "reservation_id" {
  description = "Customer-specified identifier to track this reservation."
  type        = string
  default     = null
}
