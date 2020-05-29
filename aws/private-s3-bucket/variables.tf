variable "region" {
  type        = string
  description = "S3 bucket region"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "tags" {
  type        = map(string)
  description = "Tags for S3 bucket"
  default     = {}
}

variable "disable_private" {
  description = "If true, disable private bucket feature"
  default     = false
}

variable "versioning" {
  type        = bool
  description = "S3 object versioning settings"
  default     = false
}

variable "logging" {
  type = list(object({
    target_bucket = string
    target_prefix = string
  }))
  description = "S3 access logging"
  default     = []
}

variable "grant" {
  type = list(object({
    id          = string
    type        = string
    permissions = list(string)
    uri         = string
  }))
  description = "S3 grants"
  default     = []
}
