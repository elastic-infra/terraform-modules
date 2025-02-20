<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create a private bucket in a recommended way

**NOTE**

This module will no longer be maintained for future release of AWS terraform provider.
Some latest attributes are not implemented.
Use the indivisual resources for unimplemented bucket properties.

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
  * abort\_incomplete\_multipart\_upload\_days is always set as 3 days
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
        days          = 120
        versions      = 3
        storage_class = "GLACIER"
      }
    ]
    noncurrent_version_expiration = [
      {
        days     = 150
        versions = 3
      }
    ]
  }
]
```

#### server\_side\_encryption\_configuration

SSE-S3 is enabled by default. You need specify nothing.

If you want to enable SSE-KMS, specify the KMS master key ID.

```hcl
sse_kms_master_key_id = "aws/s3" # or your CMK ID
```

If you want to disable server side encryption, set disable\_sse as `true`.

```hcl
disable_sse = true
```

#### CORS headers

```hcl
cors_rule = [{
  allowed_origins = ["*"]
  allowed_methods = ["GET", "POST"]
  allowed_headers = ["*"]
  expose_headers  = []
  max_age_seconds = 3000
}]
```

#### Object Lock configuration

```hcl
object_lock_configuration = [
  {
    rule = {
      default_retention = {
        mode  = "COMPLIANCE"
        days  = 180
        years = null
      }
    }
  }
]
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name | `string` | n/a | yes |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | S3 CORS headers | <pre>list(object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = list(string)<br/>    max_age_seconds = number<br/>  }))</pre> | `[]` | no |
| <a name="input_disable_private"></a> [disable\_private](#input\_disable\_private) | If true, disable private bucket feature | `bool` | `false` | no |
| <a name="input_disable_sse"></a> [disable\_sse](#input\_disable\_sse) | If true, disable server side encryption | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Boolean that indicates all objects (including any [locked objects](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lock-overview.html)) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_grant"></a> [grant](#input\_grant) | S3 grants | <pre>list(object({<br/>    id          = string<br/>    type        = string<br/>    permissions = list(string)<br/>    uri         = string<br/>  }))</pre> | `[]` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | S3 lifecycle rule | <pre>list(object({<br/>    id      = string<br/>    enabled = optional(bool, true)<br/>    prefix  = optional(string)<br/>    tags    = optional(map(string), {})<br/>    transition = optional(list(object({<br/>      date          = optional(string)<br/>      days          = optional(number)<br/>      storage_class = string<br/>    })), [])<br/>    # Note for expiration, noncurrent_version_transition, noncurrent_version_expiration<br/>    # define as list for simplicity, though expected only a single object<br/>    expiration = optional(list(object({<br/>      date                         = optional(string)<br/>      days                         = optional(number)<br/>      expired_object_delete_marker = optional(bool, false)<br/>    })), [])<br/>    noncurrent_version_transition = optional(list(object({<br/>      days          = number<br/>      versions      = optional(number)<br/>      storage_class = string<br/>    })), [])<br/>    noncurrent_version_expiration = optional(list(object({<br/>      days     = number<br/>      versions = optional(number)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | S3 access logging | <pre>list(object({<br/>    target_bucket = string<br/>    target_prefix = string<br/>  }))</pre> | `[]` | no |
| <a name="input_mfa_delete"></a> [mfa\_delete](#input\_mfa\_delete) | Enable MFA delete, this requires the versioning feature | `bool` | `false` | no |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | S3 Object Lock Configuration. You can only enable S3 Object Lock for new buckets. If you need to turn on S3 Object Lock for an existing bucket, please contact AWS Support. | <pre>list(object({<br/>    rule = object({<br/>      default_retention = object({<br/>        mode  = string<br/>        days  = number<br/>        years = number<br/>      })<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. | `string` | `null` | no |
| <a name="input_sse_kms_master_key_id"></a> [sse\_kms\_master\_key\_id](#input\_sse\_kms\_master\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption. | `string` | `null` | no |
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
