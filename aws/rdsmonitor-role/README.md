<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

RDS monitoring role

### Usage

```hcl
module "rds-monitor-role" {
  source = "github.com/elastic-infra/terraform-modules//aws/rdsmonitor-role?ref=v1.2.0"

  role_name = "manaita-operator"
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
| [aws_iam_role.rds_monitor_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.rds_monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.rdsmonitor-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | RDS monitoring role name | `string` | `"rds-monitoring-role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | RDS monitoring role ARN |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | RDS monitoring role name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
