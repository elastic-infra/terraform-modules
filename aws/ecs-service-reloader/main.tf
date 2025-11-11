/**
* ## Information
*
* This module reloads ECS service according to the specified schedule.
*
* ### Usage
*
* ```hcl
* module "ecs_service_reloader" {
*   source = "github.com/elastic-infra/terraform-modules//aws/ecs-service-reloader?ref=v9.1.0"
*
*   infra_env = var.infra_env
*   targets = [
*     {
*       cluster_name = aws_ecs_cluster.example.name
*       service_name = aws_ecs_service.example.name
*       schedule     = "cron(0 0 * * ? *)"
*       group_name   = "ecs_reload"
*       timezone     = "UTC"
*     },
*   ],
* }
* ```
*
*/
