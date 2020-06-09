<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Basic IAM groups

### Usage

```hcl
module "base_group" {
  source = "github.com/elastic-infra/terraform-modules//aws/base-infra-group?ref=v1.3.0"

  reader_group_name = "iam-reader"
  system_group_name = "infra-system"
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
| reader\_group\_name | Name of IAM reader group | `string` | `"iam-reader"` | no |
| system\_group\_name | Name of system group | `string` | `"infra-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_reader\_group\_name | Name of IAM reader group |
| infra\_system\_group\_name | Name of system group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
