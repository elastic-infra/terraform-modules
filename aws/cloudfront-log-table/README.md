<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Athena table for CloudFront log

Notice: This module does not support partitioning.

### Usage

```hcl
module "main" {
  source = "github.com/elastic-infra/terraform-modules//aws/cloudfront-log-table?ref=v2.7.0"

  name          = "main"
  database_name = "cflog"
  location      = "s3://cloudfront-log/main"
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

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
