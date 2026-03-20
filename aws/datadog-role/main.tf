/**
* ## Information
*
* Datadog AWS Integration IAM Role
*
* Creates an IAM role with the permissions required for the Datadog AWS integration.
* Permission sets are based on the official Datadog CloudFormation template.
*
* ### Usage
*
* ```hcl
* module "datadog_role" {
*   source = "github.com/elastic-infra/terraform-modules//aws/datadog-role?ref=v1.0.0"
*
*   external_ids = ["abcdef1234567890abcdef1234567890"]
* }
* ```
*
*/
