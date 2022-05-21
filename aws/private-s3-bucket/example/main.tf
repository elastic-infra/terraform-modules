data "aws_canonical_user_id" "current" {}

module "example_bucket" {
  # source = "github.com/elastic-infra/terraform-modules//aws/private-s3-bucket?ref=v3.0.0"
  source      = "../"
  bucket_name = "ei-private-s3-example-bucket"

  grant = [
    {
      id          = data.aws_canonical_user_id.current.id
      type        = "CanonicalUser"
      permissions = ["FULL_CONTROL"]
      uri         = null
    },
    {
      id          = null
      type        = "Group"
      permissions = ["WRITE", "READ_ACP"]
      uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    }
  ]

  lifecycle_rule = [
    {
      id                                     = "t01"
      enabled                                = true
      prefix                                 = "p1"
      tags                                   = {}
      abort_incomplete_multipart_upload_days = 3
      transition                             = []
      expiration = [
        {
          date                         = null
          days                         = 0
          expired_object_delete_marker = false
        },
      ]
      noncurrent_version_transition = []
      noncurrent_version_expiration = []
    },
    {
      id      = "t02"
      enabled = true
      # Both prefix and multiple tags
      prefix = "p2"
      tags = {
        x = "y"
        z = "w"
      }
      abort_incomplete_multipart_upload_days = null
      transition = [
        {
          date          = null
          days          = 40
          storage_class = "STANDARD_IA"
        },
      ]
      expiration = [
        {
          date                         = null
          days                         = 100
          expired_object_delete_marker = false
        },
      ]
      noncurrent_version_transition = [
        {
          storage_class             = "ONEZONE_IA"
          newer_noncurrent_versions = 3
          days                      = 40
        },
      ]
      noncurrent_version_expiration = [
        {
          days = 200
        },
      ]
    },
    {
      id      = "t03"
      enabled = true
      # Both prefix and single tag
      prefix = "p3"
      tags = {
        m = "n"
      }
      abort_incomplete_multipart_upload_days = null
      transition                             = []
      expiration = [
        {
          date                         = null
          days                         = 30
          expired_object_delete_marker = false
        },
      ]
      noncurrent_version_transition = []
      noncurrent_version_expiration = []
    },
    {
      id      = "t04"
      enabled = true
      # Only prefix, no tag
      prefix                                 = "p4"
      tags                                   = {}
      abort_incomplete_multipart_upload_days = null
      transition                             = []
      expiration = [
        {
          date                         = null
          days                         = 30
          expired_object_delete_marker = false
        },
      ]
      noncurrent_version_transition = []
      noncurrent_version_expiration = []
    },
    {
      id      = "t05"
      enabled = true
      # Only single tag, no prefix
      prefix = null
      tags = {
        m = "n"
      }
      abort_incomplete_multipart_upload_days = null
      transition                             = []
      expiration = [
        {
          date                         = null
          days                         = 30
          expired_object_delete_marker = false
        },
      ]
      noncurrent_version_transition = []
      noncurrent_version_expiration = []
    },
  ]

  cors_rule = [{
    allowed_origins = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_headers = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }]
}
