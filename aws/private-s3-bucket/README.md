<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create a private bucket in a recommended way

### Usage

```hcl
module "bucket" {
  source = "github.com/elastic-infra/terraform-modules//aws/private-s3-bucket?ref=v2.1.0"

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26, < 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | S3 CORS headers | <pre>list(object({<br>    allowed_headers = list(string)<br>    allowed_methods = list(string)<br>    allowed_origins = list(string)<br>    expose_headers  = list(string)<br>    max_age_seconds = number<br>  }))</pre> | `[]` | no |
| <a name="input_disable_private"></a> [disable\_private](#input\_disable\_private) | If true, disable private bucket feature | `bool` | `false` | no |
| <a name="input_grant"></a> [grant](#input\_grant) | S3 grants | <pre>list(object({<br>    id          = string<br>    type        = string<br>    permissions = list(string)<br>    uri         = string<br>  }))</pre> | `[]` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | S3 lifecycle rule | <pre>list(object({<br>    id                                     = string<br>    enabled                                = bool<br>    prefix                                 = string<br>    abort_incomplete_multipart_upload_days = number<br>    tags                                   = map(string)<br>    transition = list(object({<br>      date          = string<br>      days          = number<br>      storage_class = string<br>    }))<br>    # Note for expiration, noncurrent_version_transition, noncurrent_version_expiration<br>    # define as list for simplicity, though expected only a single object<br>    expiration = list(object({<br>      date                         = string<br>      days                         = number<br>      expired_object_delete_marker = bool<br>    }))<br>    noncurrent_version_transition = list(object({<br>      days          = number<br>      storage_class = string<br>    }))<br>    noncurrent_version_expiration = list(object({<br>      days = number<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | S3 access logging | <pre>list(object({<br>    target_bucket = string<br>    target_prefix = string<br>  }))</pre> | `[]` | no |
| <a name="input_mfa_delete"></a> [mfa\_delete](#input\_mfa\_delete) | S3 object MFA delete settings | `bool` | `null` | no |
| <a name="input_server_side_encryption_configuration"></a> [server\_side\_encryption\_configuration](#input\_server\_side\_encryption\_configuration) | Server-side encryption configuration | <pre>list(object({<br>    rule = object({<br>      apply_server_side_encryption_by_default = object({<br>        sse_algorithm     = string<br>        kms_master_key_id = string<br>      })<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for S3 bucket | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | S3 object versioning settings | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 Bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Domain name of the S3 Bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 Bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Region-specific domain name of the S3 Bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
