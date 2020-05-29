/**
* ## Information
*
* Create a private bucket in a recommended way
*
* ### Usage
*
* ```hcl
* module "bucket" {
*   source = "github.com/elastic-infra/terraform-modules//aws/private-s3-bucket?ref=v1.2.0"
*
*   region      = "us-east-1"
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
*/

locals {
  block_access_enabled = ! var.disable_private
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  region = var.region
  acl    = length(var.grant) > 0 ? null : "private"
  tags   = var.tags

  versioning {
    enabled = var.versioning
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
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  # ACL should always not be used nor used
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = local.block_access_enabled
  restrict_public_buckets = local.block_access_enabled
}
