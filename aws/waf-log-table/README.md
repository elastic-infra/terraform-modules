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
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| database\_name | Name of the metadata database where the table metadata resides. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| location | The s3 location of the WAF log. (ex: s3://athenawaflogs/WebACL/) | `string` | n/a | yes |
| name | Name of the table. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| partition\_range | A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types. | `string` | `"NOW-1MONTH,NOW"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
