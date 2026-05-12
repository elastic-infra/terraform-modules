<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Distributes the AWS DevOps Agent Source Role to AWS Organizations member
accounts via a service-managed CloudFormation StackSet.

### Prerequisites

- The calling account must be a registered CloudFormation StackSets delegated
  administrator. This module always sets `call_as = "DELEGATED_ADMIN"` and
  does not support being invoked from the Organizations management account.
- `stacksets.cloudformation.amazonaws.com` must be present in
  `aws_organizations_organization.aws_service_access_principals`

### Behavior

- Distributes the same Source Role (default name: `AWSDevOpsAgentSourceRole`)
  to every workload account under the configured OUs
- Trust conditions: `aws:SourceAccount = <monitoring_account_id>` and
  `aws:SourceArn ArnLike "arn:aws:aidevops:<monitoring_region>:<monitoring_account_id>:agentspace/*"`
- Includes an inline policy that lets the role create the Resource Explorer
  service-linked role on first investigation
- The CloudFormation template receives monitoring identifiers via Parameters
  so the template stays organization-agnostic

### Usage

```hcl
module "devops_agent_source_role_stackset" {
  source = "github.com/elastic-infra/terraform-modules//aws/devops-agent-source-role-stackset?ref=v1.0.0"

  organizational_unit_ids = [
    "ou-xxxx-aaaaaaaa", # production
    "ou-xxxx-bbbbbbbb", # development
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_instances.source_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_instances) | resource |
| [aws_cloudformation_stack_set.source_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organizational_unit_ids"></a> [organizational\_unit\_ids](#input\_organizational\_unit\_ids) | OU IDs to deploy AWSDevOpsAgentSourceRole to. The StackSet auto-deploys to all accounts under these OUs. | `list(string)` | n/a | yes |
| <a name="input_managed_policy_name"></a> [managed\_policy\_name](#input\_managed\_policy\_name) | AWS managed policy name attached to the role. | `string` | `"AIDevOpsAgentAccessPolicy"` | no |
| <a name="input_monitoring_account_id"></a> [monitoring\_account\_id](#input\_monitoring\_account\_id) | AWS DevOps Agent monitoring (admin) account id used in aws:SourceAccount trust condition. If null, the caller's account id is used. | `string` | `null` | no |
| <a name="input_monitoring_region"></a> [monitoring\_region](#input\_monitoring\_region) | Region where the Agent Space is deployed. Used in aws:SourceArn ArnLike trust condition. | `string` | `"ap-northeast-1"` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | Regions in which StackSet instance metadata is recorded. The IAM role itself is global, so a single region is enough. | `list(string)` | <pre>[<br/>  "ap-northeast-1"<br/>]</pre> | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | IAM role name created in each workload account. | `string` | `"AWSDevOpsAgentSourceRole"` | no |
| <a name="input_stack_set_name"></a> [stack\_set\_name](#input\_stack\_set\_name) | Name of the CloudFormation StackSet. | `string` | `"AWSDevOpsAgentSourceRole"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the StackSet resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | IAM role name distributed to each workload account. |
| <a name="output_stack_set_id"></a> [stack\_set\_id](#output\_stack\_set\_id) | ID of the CloudFormation StackSet. |
| <a name="output_stack_set_name"></a> [stack\_set\_name](#output\_stack\_set\_name) | Name of the CloudFormation StackSet that distributes AWSDevOpsAgentSourceRole. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->