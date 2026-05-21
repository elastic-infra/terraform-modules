/**
* ## Information
*
* Provisions resources on the AWS DevOps Agent Monitoring (admin) account side.
* Creates a single Agent Space, two associated IAM roles (Agent Space / Operator App),
* and an Association that registers the Monitoring account itself as primary (monitor).
* Optionally registers workload accounts as source associations via `source_account_ids`.
*
* Instantiate this module multiple times to isolate workloads into separate Agent Spaces.
*
* ### Prerequisites
*
* - awscc >= 1.66
* - Supported regions: us-east-1, us-west-2, ap-southeast-2,
*   ap-northeast-1, eu-central-1, eu-west-1
* - IAM Identity Center is enabled in the account (required by Operator App)
* - For each account in `source_account_ids`, AWSDevOpsAgentSourceRole must be
*   deployed (typically via the devops-agent-source-role-stackset module)
*
* ### Usage
*
* ```hcl
* locals {
*   agent_spaces = {
*     prod = {
*       description        = "AgentSpace for prod workload"
*       source_account_ids = ["111111111111"]
*     }
*     dev = {
*       description        = "AgentSpace for dev workload"
*       source_account_ids = ["222222222222"]
*     }
*   }
* }
*
* module "devops_agent_source_role_stackset" {
*   source = "github.com/elastic-infra/terraform-modules//aws/devops-agent-source-role-stackset?ref=v1.0.0"
*
*   organizational_unit_ids = ["ou-xxxx-xxxxxxxx"]
* }
*
* module "devops_agent_monitor" {
*   source   = "github.com/elastic-infra/terraform-modules//aws/devops-agent-monitor?ref=v1.0.0"
*   for_each = local.agent_spaces
*
*   agent_space_name        = each.key
*   agent_space_description = each.value.description
*   source_account_ids      = each.value.source_account_ids
*
*   depends_on = [module.devops_agent_source_role_stackset]
* }
* ```
*
*/
