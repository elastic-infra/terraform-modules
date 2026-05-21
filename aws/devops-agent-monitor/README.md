<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Provisions resources on the AWS DevOps Agent Monitoring (admin) account side.
Creates a single Agent Space, two associated IAM roles (Agent Space / Operator App),
and an Association that registers the Monitoring account itself as primary (monitor).
Optionally registers workload accounts as source associations via `source_account_ids`.

Instantiate this module multiple times to isolate workloads into separate Agent Spaces.

### Prerequisites

- awscc >= 1.66
- Supported regions: us-east-1, us-west-2, ap-southeast-2,
  ap-northeast-1, eu-central-1, eu-west-1
- IAM Identity Center is enabled in the account (required by Operator App)
- For each account in `source_account_ids`, AWSDevOpsAgentSourceRole must be
  deployed (typically via the devops-agent-source-role-stackset module)

### Usage

```hcl
module "devops_agent_monitor" {
  source = "github.com/elastic-infra/terraform-modules//aws/devops-agent-monitor?ref=v1.0.0"

  agent_space_name        = "my-agent-space"
  agent_space_description = "AgentSpace for production workload"
  source_account_ids      = ["123456789012"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.29 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 1.66 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.46.0 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | 1.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.agent_space](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policies_exclusive.agent_space_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policies_exclusive) | resource |
| [aws_iam_role_policy.agent_space_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachments_exclusive.agent_space_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_iam_role_policy_attachments_exclusive.operator_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [awscc_devopsagent_agent_space.this](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/devopsagent_agent_space) | resource |
| [awscc_devopsagent_association.primary](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/devopsagent_association) | resource |
| [awscc_devopsagent_association.source](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/devopsagent_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.agent_space_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.agent_space_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.operator_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_space_name"></a> [agent\_space\_name](#input\_agent\_space\_name) | Name of the AWS DevOps Agent Agent Space. Must be unique within the account/region. | `string` | n/a | yes |
| <a name="input_agent_space_description"></a> [agent\_space\_description](#input\_agent\_space\_description) | Description of the Agent Space. | `string` | `""` | no |
| <a name="input_agent_space_managed_policy_arns"></a> [agent\_space\_managed\_policy\_arns](#input\_agent\_space\_managed\_policy\_arns) | AWS managed policy ARNs attached to the Agent Space role. | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/AIDevOpsAgentAccessPolicy"<br/>]</pre> | no |
| <a name="input_agent_space_role_name"></a> [agent\_space\_role\_name](#input\_agent\_space\_role\_name) | IAM role name assumed by the Agent Space (aidevops.amazonaws.com). Defaults to DevOpsAgent-<agent\_space\_name>-Space. | `string` | `null` | no |
| <a name="input_operator_managed_policy_arns"></a> [operator\_managed\_policy\_arns](#input\_operator\_managed\_policy\_arns) | AWS managed policy ARNs attached to the Operator role. | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/AIDevOpsOperatorAppAccessPolicy"<br/>]</pre> | no |
| <a name="input_operator_role_name"></a> [operator\_role\_name](#input\_operator\_role\_name) | IAM role name assumed by the Operator App. Defaults to DevOpsAgent-<agent\_space\_name>-WebappAdmin. | `string` | `null` | no |
| <a name="input_source_account_ids"></a> [source\_account\_ids](#input\_source\_account\_ids) | AWS account IDs to register as source (workload) accounts on the Agent Space. The AWSDevOpsAgentSourceRole role must already be deployed in each account (typically via the devops-agent-source-role-stackset module). | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the IAM roles created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_space_arn"></a> [agent\_space\_arn](#output\_agent\_space\_arn) | ARN of the created Agent Space. |
| <a name="output_agent_space_id"></a> [agent\_space\_id](#output\_agent\_space\_id) | ID of the created Agent Space. |
| <a name="output_agent_space_name"></a> [agent\_space\_name](#output\_agent\_space\_name) | Name of the created Agent Space. |
| <a name="output_agent_space_role_arn"></a> [agent\_space\_role\_arn](#output\_agent\_space\_role\_arn) | ARN of the IAM role assumed by the Agent Space (primary monitor association uses this). |
| <a name="output_operator_role_arn"></a> [operator\_role\_arn](#output\_operator\_role\_arn) | ARN of the IAM role assumed by the Operator App. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->