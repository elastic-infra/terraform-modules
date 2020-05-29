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
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| role\_name | RDS monitoring role name | `string` | `"rds-monitoring-role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| role\_arn | RDS monitoring role ARN |
| role\_name | RDS monitoring role name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
