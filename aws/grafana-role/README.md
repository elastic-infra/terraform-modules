<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Grafana monitoring role

### Usage

```hcl
module "grafana-role" {
  source = "github.com/elastic-infra/terraform-modules//aws/grafana-role?ref=v4.2.0"

  prefix                  = "prefix"
  athena_workgroups       = [aws_athena_workgroup.infra.arn]
  athena_result_bucket    = module.athena_bucket.bucket_arn
  athena_search_buckets   = [module.log_bucket.bucket_arn]
  cwlogs_search_loggroups = [data.aws_cloudwatch_log_group.rds_slowquery.arn]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assumerole_principals"></a> [assumerole\_principals](#input\_assumerole\_principals) | ARN list of principals to invoke assumerole | `list(string)` | <pre>[<br>  "arn:aws:iam::089928438340:role/eicommonprod-grafana-ec2"<br>]</pre> | no |
| <a name="input_athena_result_bucket"></a> [athena\_result\_bucket](#input\_athena\_result\_bucket) | Bucket ARN of Athena's result | `string` | `null` | no |
| <a name="input_athena_search_buckets"></a> [athena\_search\_buckets](#input\_athena\_search\_buckets) | ARN list of buckets searched by Athena | `list(string)` | `[]` | no |
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | ARN list of WorkGroups | `list(string)` | `[]` | no |
| <a name="input_cwlogs_search_loggroups"></a> [cwlogs\_search\_loggroups](#input\_cwlogs\_search\_loggroups) | ARN list of LogGroups searched by CloudWatch Logs Insight | `list(string)` | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all resources | `string` | `"ei"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Grafana monitoring role ARN |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Grafana monitoring role name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
