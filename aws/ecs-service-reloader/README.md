## Information

This module reloads ECS service according to the specified schedule.

### Usage

```hcl
module "ecs_service_reloader" {
  source = "github.com/elastic-infra/terraform-modules//aws/ecs-service-reloader?ref=v9.1.0"

  infra_env = var.infra_env
  targets = [
    {
      cluster_name = aws_ecs_cluster.example.name
      service_name = aws_ecs_service.example.name
      schedule     = "cron(0 0 * * ? *)"
      group_name   = "ecs_reload"
      timezone     = "UTC"
    },
  ],
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_scheduler_reload_ecs_role"></a> [scheduler\_reload\_ecs\_role](#module\_scheduler\_reload\_ecs\_role) | github.com/elastic-infra/terraform-modules//aws/iam-service-role | v9.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_scheduler_schedule.reload_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_service) | data source |
| [aws_iam_policy_document.scheduler_reload_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_infra_env"></a> [infra\_env](#input\_infra\_env) | infra env | `string` | n/a | yes |
| <a name="input_targets"></a> [targets](#input\_targets) | Target and schedule settings | <pre>list(object({<br/>    cluster_name = string<br/>    service_name = string<br/>    schedule     = string<br/>    group_name   = optional(string, "default")<br/>    timezone     = optional(string, "Asia/Tokyo")<br/>    state        = optional(string, "ENABLED")<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
