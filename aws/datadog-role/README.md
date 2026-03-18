<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Datadog AWS Integration IAM Role

Creates an IAM role with the permissions required for the Datadog AWS integration.
Permission sets are based on the official Datadog CloudFormation template.

### Usage

```hcl
module "datadog_role" {
  source = "github.com/elastic-infra/terraform-modules//aws/datadog-role?ref=v1.0.0"

  external_ids = ["abcdef1234567890abcdef1234567890"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.49 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.extended](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachments_exclusive.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.extended](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_ids"></a> [external\_ids](#input\_external\_ids) | External IDs that Datadog uses for assuming the role | `list(string)` | n/a | yes |
| <a name="input_additional_policy_arns"></a> [additional\_policy\_arns](#input\_additional\_policy\_arns) | Additional IAM managed policy ARNs to attach to Datadog role | `list(string)` | `[]` | no |
| <a name="input_cspm_permissions"></a> [cspm\_permissions](#input\_cspm\_permissions) | Attach SecurityAudit managed policy for Cloud Security Posture Management | `bool` | `true` | no |
| <a name="input_custom_policy_name"></a> [custom\_policy\_name](#input\_custom\_policy\_name) | Custom policy name that Datadog role uses | `string` | `"DatadogAWSIntegrationPolicy"` | no |
| <a name="input_datadog_aws_account_id"></a> [datadog\_aws\_account\_id](#input\_datadog\_aws\_account\_id) | Datadog AWS account ID for trust policy | `string` | `"464622532012"` | no |
| <a name="input_datadog_role_name"></a> [datadog\_role\_name](#input\_datadog\_role\_name) | AWS IAM Role name for Datadog | `string` | `"DatadogIntegrationRole"` | no |
| <a name="input_full_permissions"></a> [full\_permissions](#input\_full\_permissions) | Grant full permissions for Datadog AWS integration. When false, only core metrics permissions are granted. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of Datadog IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of Datadog IAM role |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->