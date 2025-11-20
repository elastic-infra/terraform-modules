resource "aws_s3_bucket_versioning" "b" {
  count  = var.versioning != null ? 1 : 0
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status     = var.versioning ? "Enabled" : "Suspended"
    mfa_delete = var.mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_logging" "b" {
  count  = length(var.logging) > 0 ? 1 : 0
  bucket = aws_s3_bucket.b.id

  target_bucket = var.logging[0].target_bucket
  target_prefix = var.logging[0].target_prefix
}

# grant
resource "aws_s3_bucket_acl" "b" {
  count  = local.object_ownership != "BucketOwnerEnforced" ? 1 : 0
  bucket = aws_s3_bucket.b.id

  acl = length(var.grant) > 0 ? null : "private"
  dynamic "access_control_policy" {
    for_each = length(var.grant) > 0 ? [1] : []
    content {
      dynamic "grant" {
        for_each = flatten(
          [for g in var.grant :
            [for p in g.permissions :
              {
                id         = g["id"]
                type       = g["type"]
                permission = p
                uri        = g["uri"]
              }
            ]
          ]
        )
        content {
          grantee {
            id   = grant.value.id
            type = grant.value.type
            uri  = grant.value.uri
          }
          permission = grant.value.permission
        }
      }
      owner {
        id = data.aws_canonical_user_id.current.id
      }
    }
  }
}

# Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "b" {
  bucket = aws_s3_bucket.b.id

  rule {
    object_ownership = local.object_ownership
  }
}

# lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "b" {
  bucket = aws_s3_bucket.b.id

  rule {
    id     = "Abort incomplete multipart upload"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 3
    }
    # to suppress warnings
    filter {}
  }

  dynamic "rule" {
    for_each = toset(var.lifecycle_rule)
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"
      filter {
        # Only prefix or only 1 tag: bare
        # both prefix and tag, multiple tags: inside `and` block
        prefix = length(rule.value.tags) == 0 ? rule.value.prefix : null
        dynamic "tag" {
          for_each = rule.value.prefix == null && length(rule.value.tags) == 1 ? [1] : []
          content {
            key   = keys(rule.value.tags)[0]
            value = values(rule.value.tags)[0]
          }
        }
        dynamic "and" {
          for_each = (rule.value.prefix != null && length(rule.value.tags) >= 1) || length(rule.value.tags) >= 2 ? [1] : []
          content {
            prefix = rule.value.prefix
            tags   = rule.value.tags
          }
        }
      }
      dynamic "transition" {
        for_each = rule.value.transition
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
      dynamic "expiration" {
        for_each = rule.value.expiration
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition
        content {
          newer_noncurrent_versions = noncurrent_version_transition.value.versions
          noncurrent_days           = noncurrent_version_transition.value.days
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration
        content {
          newer_noncurrent_versions = noncurrent_version_expiration.value.versions
          noncurrent_days           = noncurrent_version_expiration.value.days
        }
      }
    }
  }
}
# SSE
resource "aws_s3_bucket_server_side_encryption_configuration" "b" {
  count  = var.disable_sse ? 0 : 1
  bucket = aws_s3_bucket.b.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.sse_kms_master_key_id
      sse_algorithm     = var.sse_kms_master_key_id == null ? "AES256" : "aws:kms"
    }
  }
}
# CORS
resource "aws_s3_bucket_cors_configuration" "b" {
  count  = length(var.cors_rule) > 0 ? 1 : 0
  bucket = aws_s3_bucket.b.id

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
# Object Lock
resource "aws_s3_bucket_object_lock_configuration" "b" {
  count  = length(var.object_lock_configuration) > 0 ? 1 : 0
  bucket = aws_s3_bucket.b.id

  rule {
    default_retention {
      mode  = var.object_lock_configuration[0].rule.default_retention.mode
      days  = var.object_lock_configuration[0].rule.default_retention.days
      years = var.object_lock_configuration[0].rule.default_retention.years
    }
  }
}

# Bucket policy for SSL-only access that can be merged with user-defined policy
data "aws_iam_policy_document" "policy" {
  count = var.manage_bucket_policy ? 1 : 0

  statement {
    sid    = "DenyNonSSLRequests"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.b.arn,
      "${aws_s3_bucket.b.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  source_policy_documents = compact([try(replace(var.bucket_policy, "\\u003cBUCKET_ARN\\u003e", aws_s3_bucket.b.arn), null)])
}

resource "aws_s3_bucket_policy" "b" {
  count = length(data.aws_iam_policy_document.policy)

  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.policy[0].json
}
