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
*   * abort_incomplete_multipart_upload_days is always set as 3 days
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
*         days          = 120
*         versions      = 3
*         storage_class = "GLACIER"
*       }
*     ]
*     noncurrent_version_expiration = [
*       {
*         days     = 150
*         versions = 3
*       }
*     ]
*   }
* ]
* ```
*
* #### server_side_encryption_configuration
*
* SSE-S3 is enabled by default. You need specify nothing.
*
* If you want to enable SSE-KMS, specify the KMS master key ID.
*
* ```hcl
* sse_kms_master_key_id = "aws/s3" # or your CMK ID
* ```
*
* If you want to disable server side encryption, set disable_sse as `true`.
*
* ```hcl
* disable_sse = true
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
  block_access_enabled = !var.disable_private
  object_ownership     = coalesce(var.object_ownership, length(var.grant) > 0 ? "ObjectWriter" : "BucketOwnerEnforced")
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags   = var.tags
  
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  # ACL should always not be used nor used
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = local.block_access_enabled
  restrict_public_buckets = local.block_access_enabled
}
