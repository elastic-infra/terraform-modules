<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

This module generates a container definition for DataDog agent.

### Prerequisite

N/A

### Usage

```hcl
module "ecs_datadog_fargate_taskdef" {
  source = "github.com/elastic-infra/terraform-modules//aws/ecs_fargate_datadog_container_definition?ref=v3.6.0"

  container = {
    name   = "datadog-agent"
    image  = "public.ecr.aws/datadog/agent:latest"
    cpu    = 10
    memory = 256
    port   = 8126
  }

  docker_labels = {
    "com.datadoghq.tags.env"     = "production"
    "com.datadoghq.tags.service" = "YOUR_SERVICE_NAME"
    "com.datadoghq.tags.version" = "1.0.0"
  }

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.datadog.name
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-stream-prefix" = "datadog"
    }
  }

  map_environments = {
    DD_APM_ENABLED          = "true"
    DD_APM_IGNORE_RESOURCES = "GET /rack-health"
    DD_ENV                  = "production"
    ECS_FARGATE             = "true"
  }

  map_secrets = {
    DD_API_KEY = aws_ssm_parameter.dd_api_key.name
  }
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
| <a name="module_container_definition"></a> [container\_definition](#module\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_configuration"></a> [log\_configuration](#input\_log\_configuration) | Log configuration options to send to a custom log driver for the container | <pre>object({<br>    logDriver     = string<br>    secretOptions = any<br>    options       = map(any)<br>  })</pre> | n/a | yes |
| <a name="input_map_environments"></a> [map\_environments](#input\_map\_environments) | The environment variables to pass to the container. This is a map of string: {key: value}. map\_environment overrides environment | `map(string)` | n/a | yes |
| <a name="input_map_secrets"></a> [map\_secrets](#input\_map\_secrets) | The secrets variables to pass to the container. This is a map of string: {key: value}. map\_secrets overrides secrets | `map(string)` | n/a | yes |
| <a name="input_container"></a> [container](#input\_container) | Basic parameters of the DataDog container | <pre>object({<br>    name   = string<br>    image  = string<br>    cpu    = number<br>    memory = number<br>    port   = number<br>  })</pre> | <pre>{<br>  "cpu": 10,<br>  "image": "public.ecr.aws/datadog/agent:latest",<br>  "memory": 256,<br>  "name": "datadog-agent",<br>  "port": 8126<br>}</pre> | no |
| <a name="input_docker_labels"></a> [docker\_labels](#input\_docker\_labels) | The configuration options to send to the docker\_labels | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_json_map_encoded"></a> [json\_map\_encoded](#output\_json\_map\_encoded) | JSON string encoded container definitions |
| <a name="output_json_map_object"></a> [json\_map\_object](#output\_json\_map\_object) | JSON map encoded container definition |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
