/**
* ## Information
*
* This module generates a container definition for DataDog agent.
*
* ### Prerequisite
*
* N/A
*
* ### Usage
*
* ```hcl
* module "ecs_datadog_fargate_taskdef" {
*   source = "github.com/elastic-infra/terraform-modules//aws/ecs_fargate_datadog_container_definition?ref=v3.6.0"
*
*   container = {
*     name   = "datadog-agent"
*     image  = "public.ecr.aws/datadog/agent:latest"
*     cpu    = 10
*     memory = 256
*     port   = 8126
*   }
*
*   docker_labels = {
*     "com.datadoghq.tags.env"     = "production"
*     "com.datadoghq.tags.service" = "YOUR_SERVICE_NAME"
*     "com.datadoghq.tags.version" = "1.0.0"
*   }
*
*   log_configuration = {
*     logDriver     = "awslogs"
*     secretOptions = null
*     options = {
*       "awslogs-group"         = aws_cloudwatch_log_group.datadog.name
*       "awslogs-region"        = data.aws_region.current.name
*       "awslogs-stream-prefix" = "datadog"
*     }
*   }
*
*   map_environments = {
*     DD_APM_ENABLED          = "true"
*     DD_APM_IGNORE_RESOURCES = "GET /rack-health"
*     DD_ENV                  = "production"
*     ECS_FARGATE             = "true"
*   }
*
*   map_secrets = {
*     DD_API_KEY = aws_ssm_parameter.dd_api_key.name
*   }
* }
* ```
*
*/

data "aws_region" "current" {}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  command                      = []
  container_name               = var.container.name
  container_image              = var.container.image
  container_cpu                = var.container.cpu
  container_memory_reservation = var.container.memory
  docker_labels                = var.docker_labels
  log_configuration            = var.log_configuration
  map_environment              = var.map_environments
  map_secrets                  = var.map_secrets

  port_mappings = [
    {
      protocol      = "tcp"
      containerPort = var.container.port
      hostPort      = var.container.port
    }
  ]
}
