<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Athena table for WAF log

### Usage

```hcl
module "main" {
  source = "github.com/elastic-infra/terraform-modules//aws/waf-log-table?ref=v2.4.0"

  name          = "main"
  database_name = "waflog"
  location      = "s3://athenawaflogs/WebACL/"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| <a name="input_location"></a> [location](#input\_location) | The s3 location of the WAF log. (ex: s3://athenawaflogs/WebACL/) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the table. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| <a name="input_partition_range"></a> [partition\_range](#input\_partition\_range) | A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types. | `string` | `"NOW-1MONTH,NOW"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
