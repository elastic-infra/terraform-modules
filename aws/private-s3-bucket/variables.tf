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

variable "force_destroy" {
  type        = bool
  description = "Boolean that indicates all objects (including any [locked objects](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html)) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
  default     = false
}

variable "mfa_delete" {
  type        = bool
  description = "Enable MFA delete, this requires the versioning feature"
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

variable "object_ownership" {
  type        = string
  description = "Object ownership."
  default     = null
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
    id      = string
    enabled = optional(bool, true)
    prefix  = optional(string)
    tags    = optional(map(string), {})
    transition = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })), [])
    # Note for expiration, noncurrent_version_transition, noncurrent_version_expiration
    # define as list for simplicity, though expected only a single object
    expiration = optional(list(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    })), [])
    noncurrent_version_transition = optional(list(object({
      days          = number
      versions      = optional(number)
      storage_class = string
    })), [])
    noncurrent_version_expiration = optional(list(object({
      days     = number
      versions = optional(number)
    })), [])
  }))
  description = "S3 lifecycle rule"
  default     = []
}

variable "disable_sse" {
  type        = bool
  description = "If true, disable server side encryption"
  default     = false
}

variable "sse_kms_master_key_id" {
  type        = string
  description = "The AWS KMS master key ID used for the SSE-KMS encryption."
  default     = null
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

variable "object_lock_configuration" {
  type = list(object({
    rule = object({
      default_retention = object({
        mode  = string
        days  = number
        years = number
      })
    })
  }))
  description = "S3 Object Lock Configuration. You can only enable S3 Object Lock for new buckets. If you need to turn on S3 Object Lock for an existing bucket, please contact AWS Support."
  default     = []

  validation {
    condition = alltrue([
      for v in var.object_lock_configuration :
      contains(["GOVERNANCE", "COMPLIANCE"], v.rule.default_retention.mode)
    ])
    error_message = "Valid values are `GOVERNANCE` and `COMPLIANCE`."
  }

  validation {
    condition = alltrue([
      for v in var.object_lock_configuration :
      (v.rule.default_retention.days != null && v.rule.default_retention.years == null) ||
      (v.rule.default_retention.days == null && v.rule.default_retention.years != null)
    ])
    error_message = "Either `days` or `years` must be specified, but not both."
  }
}
