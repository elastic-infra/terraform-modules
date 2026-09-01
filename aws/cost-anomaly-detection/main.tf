/**
* ## Information
*
* AWS Cost Anomaly Detection (monitor + subscription + notification SNS topic).
* Notification destinations (e.g. AWS Chatbot / Slack) are configured by the caller
* using the `sns_topic_arn` output.
*
* ### Usage
*
* To monitor multiple dimensions, call this module once per dimension so each can
* have its own threshold policy. Notification destinations can share topics by
* combining their `sns_topic_arn` outputs.
*
* ```hcl
* module "cost_anomaly_service" {
*   source = "github.com/elastic-infra/terraform-modules//aws/cost-anomaly-detection?ref=vX.Y.Z"
*
*   name              = "CostAnomalyService"
*   monitor_dimension = "SERVICE"
*   threshold = {
*     percentage = 10
*   }
*
*   sns = {
*     topic_name = "anomaly-notifications-service"
*   }
* }
*
* module "cost_anomaly_linked_account" {
*   source = "github.com/elastic-infra/terraform-modules//aws/cost-anomaly-detection?ref=vX.Y.Z"
*
*   name              = "CostAnomalyLinkedAccount"
*   monitor_dimension = "LINKED_ACCOUNT"
*   threshold = {
*     percentage = 10
*   }
*
*   sns = {
*     topic_name = "anomaly-notifications-linked-account"
*   }
* }
*
* resource "aws_chatbot_slack_channel_configuration" "anomaly_notifications" {
*   configuration_name = "example-anomaly-channel"
*   iam_role_arn        = module.chatbot_role.role_arn
*   slack_channel_id    = "C0XXXXXXXXX"
*   slack_team_id       = data.aws_chatbot_slack_workspace.example.slack_team_id
*
*   sns_topic_arns = [
*     module.cost_anomaly_service.sns_topic_arn,
*     module.cost_anomaly_linked_account.sns_topic_arn,
*   ]
* }
* ```
*
*/

data "aws_caller_identity" "current" {}
