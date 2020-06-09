<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create a base-role for elastic-infra

### Usage

```hcl
module "ei_base_role" {
  source = "github.com/elastic-infra/terraform-modules//aws/ei-base-role?ref=v1.3.0"

  prefix            = var.infra_env
  additional_policy = data.aws_iam_policy_document.base.json
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_policy | Policy that merge into the base policy | `string` | `""` | no |
| prefix | Prefix for all resources | `string` | `"ei"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_arn | ARN of Base policy |
| profile\_name | Name of Base instance profile |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
