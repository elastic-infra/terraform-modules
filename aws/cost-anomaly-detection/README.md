<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

AWS Cost Anomaly Detection (monitor + subscription + notification SNS topic).
Notification destinations (e.g. AWS Chatbot / Slack) are configured by the caller
using the `sns_topic_arn` output.

### Usage

To monitor multiple dimensions, call this module once per dimension so each can
have its own threshold policy. Notification destinations can share topics by
combining their `sns_topic_arn` outputs.

```hcl
module "cost_anomaly_service" {
  source = "github.com/elastic-infra/terraform-modules//aws/cost-anomaly-detection?ref=vX.Y.Z"

  name              = "CostAnomalyService"
  monitor_dimension = "SERVICE"
  threshold = {
    percentage = 10
  }

  sns = {
    topic_name = "anomaly-notifications-service"
  }
}

module "cost_anomaly_linked_account" {
  source = "github.com/elastic-infra/terraform-modules//aws/cost-anomaly-detection?ref=vX.Y.Z"

  name              = "CostAnomalyLinkedAccount"
  monitor_dimension = "LINKED_ACCOUNT"
  threshold = {
    percentage = 10
  }

  sns = {
    topic_name = "anomaly-notifications-linked-account"
  }
}

resource "aws_chatbot_slack_channel_configuration" "anomaly_notifications" {
  configuration_name = "example-anomaly-channel"
  iam_role_arn        = module.chatbot_role.role_arn
  slack_channel_id    = "C0XXXXXXXXX"
  slack_team_id       = data.aws_chatbot_slack_workspace.example.slack_team_id

  sns_topic_arns = [
    module.cost_anomaly_service.sns_topic_arn,
    module.cost_anomaly_linked_account.sns_topic_arn,
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ce_anomaly_monitor.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor) | resource |
| [aws_ce_anomaly_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Base name used for the anomaly monitor and subscription | `string` | n/a | yes |
| <a name="input_sns"></a> [sns](#input\_sns) | SNS topic settings for anomaly notifications. | <pre>object({<br/>    topic_name        = string<br/>    kms_master_key_id = optional(string, "alias/aws/sns")<br/>  })</pre> | n/a | yes |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Anomaly impact threshold settings. At least one of absolute\_usd or percentage must be set; combine\_with (AND or OR) is required when both are set | <pre>object({<br/>    absolute_usd = optional(number)<br/>    percentage   = optional(number)<br/>    combine_with = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_monitor_dimension"></a> [monitor\_dimension](#input\_monitor\_dimension) | Cost dimension to monitor for anomalies. Allowed values: SERVICE, LINKED\_ACCOUNT | `string` | `"SERVICE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_monitor_arn"></a> [monitor\_arn](#output\_monitor\_arn) | ARN of the cost anomaly monitor |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic used for anomaly notifications |
| <a name="output_subscription_arn"></a> [subscription\_arn](#output\_subscription\_arn) | ARN of the cost anomaly subscription |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
