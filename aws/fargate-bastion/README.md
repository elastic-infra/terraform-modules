<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

This module creates ECS cluster and Task Definition for Socks5 proxy.

### Usage

```hcl
module "bastion" {
  source = "github.com/elastic-infra/terraform-modules//aws/fargate-bastion?ref=v6.4.0"

  prefix = "production"

  ecs = {
    subnets = module.vpc.private_subnets
    security_groups = [
      module.vpc.default_security_group_id,
    ]
  }
}

resource "local_file" "proxy_command" {
  content  = module.bastion.command
  filename = "${path.root}/start_port_forwarding_to_socks_server.sh"

  file_permission = "0755"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | cloudposse/ecs-container-definition/aws | 0.60.1 |
| <a name="module_ecs_bastion_task_execution_role"></a> [ecs\_bastion\_task\_execution\_role](#module\_ecs\_bastion\_task\_execution\_role) | ../iam-service-role | n/a |
| <a name="module_ecs_bastion_task_role"></a> [ecs\_bastion\_task\_role](#module\_ecs\_bastion\_task\_role) | ../iam-service-role | n/a |
| <a name="module_timer"></a> [timer](#module\_timer) | cloudposse/ecs-container-definition/aws | 0.60.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_task_definition.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy_document.ecs_bastion_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs"></a> [ecs](#input\_ecs) | Parameters of ECS bastion | <pre>object({<br/>    cluster            = optional(string)<br/>    subnets            = list(string)<br/>    security_groups    = list(string)<br/>    container_insights = optional(bool, false)<br/>    log_configuration = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>      secretOptions = optional(list(object({<br/>        name      = string<br/>        valueFrom = string<br/>      })))<br/>    }))<br/>    log_configuration_timer = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>      secretOptions = optional(list(object({<br/>        name      = string<br/>        valueFrom = string<br/>      })))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | ECS task timeout | `number` | `3600` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_command"></a> [command](#output\_command) | Output execute command for start-session to ecs container |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of ECS task role |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
