/**
* ## Information
*
* Create a private bucket in a recommended way
*
* **NOTE**
*
* This module will no longer be maintained for future release of AWS terraform provider.
* Some latest attributes are not implemented.
* Use the indivisual resources for unimplemented bucket properties.
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
*   allowed_methods = ["GET", "POST"]
*   allowed_headers = ["*"]
*   expose_headers  = []
*   max_age_seconds = 3000
* }]
* ```
*
* #### Object Lock configuration
*
* ```hcl
* object_lock_configuration = [
*   {
*     rule = {
*       default_retention = {
*         mode  = "COMPLIANCE"
*         days  = 180
*         years = null
*       }
*     }
*   }
* ]
* ```
*
*/

# For "grant"
data "aws_canonical_user_id" "current" {}

locals {
  block_access_enabled = ! var.disable_private
  versioning_count     = (var.versioning != null ? 1 : 0)
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  # ACL should always not be used nor used
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = local.block_access_enabled
  restrict_public_buckets = local.block_access_enabled
}
