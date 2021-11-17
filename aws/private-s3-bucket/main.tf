/**
* ## Information
*
* Create a private bucket in a recommended way
*
* ### Usage
*
* ```hcl
* module "bucket" {
*   source = "github.com/elastic-infra/terraform-modules//aws/private-s3-bucket?ref=v2.1.0"
*
*   bucket_name = "bucket_name"
*
*   tags = {
*     Environment = "Production"
*   }
* }
* ```
*
* ### Complex Inputs
*
* #### grant
*
* Need to specify all keys, `null` if not used.
*
* ```hcl
* grant = [
*   {
*     id          = data.aws_canonical_user_id.current.id
*     type        = "CanonicalUser"
*     permissions = ["FULL_CONTROL"]
*     uri         = null
*   },
*   {
*     id          = null
*     type        = "Group"
*     permissions = ["WRITE", "READ_ACP"]
*     uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
*   }
* ]
* ```
*
* #### logging
*
* ```hcl
* logging = [
*   {
*     target_bucket = aws_s3_bucket.system_log.id
*     target_prefix = "s3_log/bucket-logs/"
*   }
* ]
* ```
*
* #### lifecycle_rule
*
* Full featured example.
*
* NOTE:
*   * abort_incomplete_multipart_upload_days is exclusive against tags
*   * expiration, noncurrent_version_{transition,expiration} can be set up to once
*
* ```hcl
* lifecycle_rule = [
*   {
*     id      = "t01"
*     enabled = true
*     prefix  = "aaa"
*     tags = {
*       a = "b"
*       c = "d"
*     }
*     abort_incomplete_multipart_upload_days = null
*     transition = [
*       {
*         date          = null
*         days          = 90
*         storage_class = "ONEZONE_IA"
*       },
*       {
*         date          = null
*         days          = 30
*         storage_class = "STANDARD_IA"
*       }
*     ]
*     expiration = [
*       {
*         date = null
*         days = 90
*         expired_object_delete_marker = false
*       }
*     ]
*     noncurrent_version_transition = [
*       {
*         days = 120
*         storage_class = "GLACIER"
*       }
*     ]
*     noncurrent_version_expiration = [
*       {
*         days = 150
*       }
*     ]
*   }
* ]
* ```
*
* #### server_side_encryption_configuration
*
* SSE-S3
*
* ```hcl
* server_side_encryption_configuration = [
*   {
*     rule = {
*       apply_server_side_encryption_by_default = {
*         sse_algorithm = "AES256"
*         kms_master_key_id = null
*       }
*     }
*   }
* ]
* ```
*
* SSE-KMS
*
* ```hcl
* server_side_encryption_configuration = [
*   {
*     rule = {
*       apply_server_side_encryption_by_default = {
*         sse_algorithm = "aws:kms"
*         kms_master_key_id = "aws/s3" # or your CMK ID
*       }
*     }
*   }
* ]
* ```
*
* #### CORS headers
*
* ```hcl
* cors_rule = [{
*   allowed_origins = ["*"]
*   allowed_methods = ["GET", "OPTIONS"]
*   allowed_headers = ["*"]
*   expose_headers  = []
*   max_age_seconds = 3000
* }]
* ```
*
*/

locals {
  block_access_enabled = !var.disable_private
  versioning_set       = (var.versioning != null ? [true] : [])
  mfa_delete_set       = (var.mfa_delete != null ? [true] : [])
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = length(var.grant) > 0 ? null : "private"
  tags   = var.tags

  dynamic "versioning" {
    for_each = local.versioning_set
    content {
      enabled = var.versioning
    }
  }

  dynamic " mfa_delete" {
    for_each = local.mfa_delete_set
    content {
      enabled = var.mfa_delete
    }
  }

  dynamic "logging" {
    for_each = var.logging
    content {
      target_bucket = logging.value.target_bucket
      target_prefix = logging.value.target_prefix
    }
  }

  dynamic "grant" {
    for_each = var.grant
    content {
      id          = grant.value.id
      type        = grant.value.type
      permissions = grant.value.permissions
      uri         = grant.value.uri
    }
  }

  /*
   * tags, enabled, abort_incomplete_multipart_upload_days,
   * expiration, transition, noncurrent_version_expiration, noncurrent_veersion_transition
   */
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lifecycle_rule.value.id
      enabled                                = lifecycle_rule.value.enabled
      prefix                                 = lifecycle_rule.value.prefix
      tags                                   = lifecycle_rule.value.tags
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days
      dynamic "transition" {
        for_each = lifecycle_rule.value.transition
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.noncurrent_version_transition
        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration
        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = server_side_encryption_configuration.value.rule.apply_server_side_encryption_by_default.sse_algorithm
          kms_master_key_id = server_side_encryption_configuration.value.rule.apply_server_side_encryption_by_default.kms_master_key_id
        }
      }
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  # ACL should always not be used nor used
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = local.block_access_enabled
  restrict_public_buckets = local.block_access_enabled
}
