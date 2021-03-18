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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.iam_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.infra_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.iam_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.system_poweruser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_reader_group_name"></a> [reader\_group\_name](#input\_reader\_group\_name) | Name of IAM reader group | `string` | `"iam-reader"` | no |
| <a name="input_system_group_name"></a> [system\_group\_name](#input\_system\_group\_name) | Name of system group | `string` | `"infra-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_reader_group_name"></a> [iam\_reader\_group\_name](#output\_iam\_reader\_group\_name) | Name of IAM reader group |
| <a name="output_infra_system_group_name"></a> [infra\_system\_group\_name](#output\_infra\_system\_group\_name) | Name of system group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
