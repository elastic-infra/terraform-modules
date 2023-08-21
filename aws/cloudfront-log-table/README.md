<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Athena table for CloudFront log

To use this module, the following application must be deployed and CloudFront logs must be partitioned.

https://serverlessrepo.aws.amazon.com/applications/ap-northeast-1/089928438340/cloudfront-log-partition

### Usage

```hcl
resource "aws_serverlessapplicationrepository_cloudformation_stack" "cloudfront_log_partition" {
  name             = "cloudfront-log-partition"
  application_id   = "arn:aws:serverlessrepo:ap-northeast-1:089928438340:applications/cloudfront-log-partition"
  semantic_version = "1.1.0"

  parameters = {
    SourceBucket         = "cloudfront-log"
    DestinationBucket    = "cloudfront-log"
    DestinationKeyPrefix = "partitioned/"
  }

  capabilities = [
    "CAPABILITY_IAM",
    "CAPABILITY_RESOURCE_POLICY",
  ]
}

resource "aws_s3_bucket_notification" "log" {
  bucket = "cloudfront-log"

  lambda_function {
    lambda_function_arn = aws_serverlessapplicationrepository_cloudformation_stack.cloudfront_log_partition.outputs["FunctionArn"]
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "main/"
  }
}

module "main" {
  source = "github.com/elastic-infra/terraform-modules//aws/cloudfront-log-table?ref=v6.3.0"

  name          = "main"
  database_name = "cflog"
  location      = "s3://cloudfront-log/partitioned/main"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_table.t](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the metadata database where the table metadata resides. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The s3 location of the CloudFront log. (ex: s3://cloudfront-log/main) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the table. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| <a name="input_partition_range"></a> [partition\_range](#input\_partition\_range) | A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types. | `string` | `"NOW-1MONTH,NOW"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
