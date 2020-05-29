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
| region | S3 bucket region | `string` | n/a | yes |
| disable\_private | If true, disable private bucket feature | `bool` | `false` | no |
| grant | S3 grants | <pre>list(object({<br>    id          = string<br>    type        = string<br>    permissions = list(string)<br>    uri         = string<br>  }))</pre> | `[]` | no |
| logging | S3 access logging | <pre>list(object({<br>    target_bucket = string<br>    target_prefix = string<br>  }))</pre> | `[]` | no |
| tags | Tags for S3 bucket | `map(string)` | `{}` | no |
| versioning | S3 object versioning settings | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | ARN of the S3 Bucket |
| bucket\_id | ID of the S3 Bucket |
| bucket\_regional\_domain\_name | Domain name of the S3 Bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
