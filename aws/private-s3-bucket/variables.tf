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
  default     = null
}

variable "mfa_delete" {
  type        = bool
  description = "S3 object MFA delete settings"
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

variable "lifecycle_rule" {
  type = list(object({
    id                                     = string
    enabled                                = bool
    prefix                                 = string
    abort_incomplete_multipart_upload_days = number
    tags                                   = map(string)
    transition = list(object({
      date          = string
      days          = number
      storage_class = string
    }))
    # Note for expiration, noncurrent_version_transition, noncurrent_version_expiration
    # define as list for simplicity, though expected only a single object
    expiration = list(object({
      date                         = string
      days                         = number
      expired_object_delete_marker = bool
    }))
    noncurrent_version_transition = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration = list(object({
      days = number
    }))
  }))
  description = "S3 lifecycle rule"
  default     = []
}

variable "server_side_encryption_configuration" {
  type = list(object({
    rule = object({
      apply_server_side_encryption_by_default = object({
        sse_algorithm     = string
        kms_master_key_id = string
      })
    })
  }))
  description = "Server-side encryption configuration"
  default     = []
}

variable "cors_rule" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  description = "S3 CORS headers"
  default     = []
}
