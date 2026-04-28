<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Athena table for Route 53 Resolver query log

Query logs are delivered as gzip-compressed JSON objects under
`AWSLogs/<account-id>/vpcdnsquerylogs/<vpc-id>/YYYY/MM/DD/`. The last
segment of `location` must be the target VPC id, so create one table
per VPC.

### Usage

```hcl
module "main" {
  source = "github.com/elastic-infra/terraform-modules//aws/resolver-query-log-table?ref=vX.Y.Z"

  name          = "main"
  database_name = "resolverquerylog"
  location      = "s3://${aws_s3_bucket.log.id}/AWSLogs/${data.aws_caller_identity.self.account_id}/vpcdnsquerylogs/${var.vpc_id}"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
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
| <a name="input_location"></a> [location](#input\_location) | The s3 location of the Route 53 Resolver query log. The last segment must be the target VPC id. (ex: s3://resolver\_query\_log\_bucket/AWSLogs/<ACCOUNT-ID>/vpcdnsquerylogs/<VPC-ID>) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the table. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| <a name="input_partition_range"></a> [partition\_range](#input\_partition\_range) | A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types. | `string` | `"NOW-1MONTH,NOW"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->