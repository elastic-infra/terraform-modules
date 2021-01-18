<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Athena table for Network Load Balancer access log

### Usage

```hcl
module "main" {
  source = "github.com/elastic-infra/terraform-modules//aws/nlb-accesslog-table?ref=v2.2.0"

  name          = "main"
  database_name = "accesslog"
  location      = "s3://your_log_bucket/prefix/AWSLogs/<ACCOUNT-ID>/elasticloadbalancing/<REGION>"
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
| location | The s3 location of the Network Load Balancer access log. (ex: s3://your\_log\_bucket/prefix/AWSLogs/<ACCOUNT-ID>/elasticloadbalancing/<REGION>) | `string` | n/a | yes |
| name | Name of the table. For Hive compatibility, this must be entirely lowercase. | `string` | n/a | yes |
| partition\_range | A two-element, comma-separated list which provides the minimum and maximum range values. These values are inclusive and can use any format compatible with the Java `java.time.*` date types. | `string` | `"NOW-1MONTH,NOW"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
