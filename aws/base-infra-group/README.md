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
| [aws_iam_group.infra_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.infra_system_ami_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.infra_system_partition_ctl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.infra_system_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.infra_system_register_r53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.infra_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy_document.infra_system_ami_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.infra_system_partition_ctl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.infra_system_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.infra_system_register_r53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.infra_system_partition_ctl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_partition_ctl_s3_bucket"></a> [partition\_ctl\_s3\_bucket](#input\_partition\_ctl\_s3\_bucket) | S3 bucket list for partition-ctl | `list(string)` | `[]` | no |
| <a name="input_system_group_name"></a> [system\_group\_name](#input\_system\_group\_name) | Name of system group | `string` | `"infra-system"` | no |
| <a name="input_use_register_r53"></a> [use\_register\_r53](#input\_use\_register\_r53) | Whether register-r53 is used or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_infra_system_group_name"></a> [infra\_system\_group\_name](#output\_infra\_system\_group\_name) | Name of system group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
