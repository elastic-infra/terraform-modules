variable "name" {
  type        = string
  description = "Name of the table. For Hive compatibility, this must be entirely lowercase."

  validation {
    condition     = can(regex("^[0-9a-z_]+$", var.name))
    error_message = "The name value must be entirely lowercase."
  }
}

variable "database_name" {
  type        = string
  description = "Name of the metadata database where the table metadata resides. For Hive compatibility, this must be entirely lowercase."

  validation {
    condition     = can(regex("^[0-9a-z_-]+$", var.database_name))
    error_message = "The name value must be entirely lowercase."
  }
}

variable "location" {
  type        = string
  description = "The s3 location of the WAF log. (ex: s3://athenawaflogs/WebACL/)"
}

variable "partition_range" {
  type        = string
  description = "A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types."
  default     = "NOW-1MONTH,NOW"
}
