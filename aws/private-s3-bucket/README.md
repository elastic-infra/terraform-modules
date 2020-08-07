<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create a private bucket in a recommended way

### Usage

```hcl
module "bucket" {
  source = "github.com/elastic-infra/terraform-modules//aws/private-s3-bucket?ref=v1.2.0"

  region      = "us-east-1"
  bucket_name = "bucket_name"

  tags = {
    Environment = "Production"
  }
}
```

### Complex Inputs

#### grant

Need to specify all keys, `null` if not used.

```hcl
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
```

#### logging

```hcl
logging = [
  {
    target_bucket = aws_s3_bucket.system_log.id
    target_prefix = "s3_log/bucket-logs/"
  }
]
```

#### lifecycle\_rule

Full featured example.

NOTE:
  * abort\_incomplete\_multipart\_upload\_days is exclusive against tags
  * expiration, noncurrent\_version\_{transition,expiration} can be set up to once

```hcl
lifecycle_rule = [
  {
    id      = "t01"
    enabled = true
    prefix  = "aaa"
    tags = {
      a = "b"
      c = "d"
    }
    abort_incomplete_multipart_upload_days = null
    transition = [
      {
        date          = null
        days          = 90
        storage_class = "ONEZONE_IA"
      },
      {
        date          = null
        days          = 30
        storage_class = "STANDARD_IA"
      }
    ]
    expiration = [
      {
        date = null
        days = 90
        expired_object_delete_marker = false
      }
    ]
    noncurrent_version_transition = [
      {
        days = 120
        storage_class = "GLACIER"
      }
    ]
    noncurrent_version_expiration = [
      {
        days = 150
      }
    ]
  }
]
```

#### server\_side\_encryption\_configuration

SSE-S3

```hcl
server_side_encryption_configuration = [
  {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
        kms_master_key_id = null
      }
    }
  }
]
```

SSE-KMS

```hcl
server_side_encryption_configuration = [
  {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
        kms_master_key_id = "aws/s3" # or your CMK ID
      }
    }
  }
]
```

#### CORS headers

```hcl
cors_rule = [{
  allowed_origins = ["*"]
  allowed_methods = ["GET", "OPTIONS"]
  allowed_headers = ["*"]
  expose_headers  = []
  max_age_seconds = 3000
}]
```

## Requirements

| Name | Version |
|------|---------|
| aws | >= 2.52.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.52.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | S3 bucket name | `string` | n/a | yes |
| cors\_rule | S3 CORS headers | <pre>list(object({<br>    allowed_headers = list(string)<br>    allowed_methods = list(string)<br>    allowed_origins = list(string)<br>    expose_headers  = list(string)<br>    max_age_seconds = number<br>  }))</pre> | `[]` | no |
| disable\_private | If true, disable private bucket feature | `bool` | `false` | no |
| grant | S3 grants | <pre>list(object({<br>    id          = string<br>    type        = string<br>    permissions = list(string)<br>    uri         = string<br>  }))</pre> | `[]` | no |
| lifecycle\_rule | S3 lifecycle rule | <pre>list(object({<br>    id                                     = string<br>    enabled                                = bool<br>    prefix                                 = string<br>    abort_incomplete_multipart_upload_days = number<br>    tags                                   = map(string)<br>    transition = list(object({<br>      date          = string<br>      days          = number<br>      storage_class = string<br>    }))<br>    # Note for expiration, noncurrent_version_transition, noncurrent_version_expiration<br>    # define as list for simplicity, though expected only a single object<br>    expiration = list(object({<br>      date                         = string<br>      days                         = number<br>      expired_object_delete_marker = bool<br>    }))<br>    noncurrent_version_transition = list(object({<br>      days          = number<br>      storage_class = string<br>    }))<br>    noncurrent_version_expiration = list(object({<br>      days = number<br>    }))<br>  }))</pre> | `[]` | no |
| logging | S3 access logging | <pre>list(object({<br>    target_bucket = string<br>    target_prefix = string<br>  }))</pre> | `[]` | no |
| region | S3 bucket region | `string` | n/a | yes |
| server\_side\_encryption\_configuration | Server-side encryption configuration | <pre>list(object({<br>    rule = object({<br>      apply_server_side_encryption_by_default = object({<br>        sse_algorithm     = string<br>        kms_master_key_id = string<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| tags | Tags for S3 bucket | `map(string)` | `{}` | no |
| versioning | S3 object versioning settings | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | ARN of the S3 Bucket |
| bucket\_domain\_name | Domain name of the S3 Bucket |
| bucket\_id | ID of the S3 Bucket |
| bucket\_regional\_domain\_name | Region-specific domain name of the S3 Bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
