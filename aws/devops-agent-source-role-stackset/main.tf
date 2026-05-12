/**
* ## Information
*
* Distributes the AWS DevOps Agent Source Role to AWS Organizations member
* accounts via a service-managed CloudFormation StackSet.
*
* ### Prerequisites
*
* - The calling account must be a registered CloudFormation StackSets delegated
*   administrator. This module always sets `call_as = "DELEGATED_ADMIN"` and
*   does not support being invoked from the Organizations management account.
* - `stacksets.cloudformation.amazonaws.com` must be present in
*   `aws_organizations_organization.aws_service_access_principals`
*
* ### Behavior
*
* - Distributes the same Source Role (default name: `AWSDevOpsAgentSourceRole`)
*   to every workload account under the configured OUs
* - Trust conditions: `aws:SourceAccount = <monitoring_account_id>` and
*   `aws:SourceArn ArnLike "arn:aws:aidevops:<monitoring_region>:<monitoring_account_id>:agentspace/*"`
* - Includes an inline policy that lets the role create the Resource Explorer
*   service-linked role on first investigation
* - The CloudFormation template receives monitoring identifiers via Parameters
*   so the template stays organization-agnostic
*
* ### Usage
*
* ```hcl
* module "devops_agent_source_role_stackset" {
*   source = "github.com/elastic-infra/terraform-modules//aws/devops-agent-source-role-stackset?ref=v1.0.0"
*
*   organizational_unit_ids = [
*     "ou-xxxx-aaaaaaaa", # production
*     "ou-xxxx-bbbbbbbb", # development
*   ]
* }
* ```
*
*/
