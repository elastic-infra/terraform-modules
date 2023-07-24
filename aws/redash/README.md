<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create Redash ECS cluster and its Application load balancer.

### Prerequisite

N/A

### Usage

```hcl
module "redash" {
  source = "github.com/elastic-infra/terraform-modules//aws/redash?ref=v3.4.0"

  container_image_url = "redash/redash:10.1.0.b50633"

  container_environments = [
    {
      name   = "(Environment variable name)"
      value  = "(plain string)"
    },
  ]

  container_secrets = [
    {
      name      = "(Secret environment variable name)"
      valueFrom = aws_ssm_parameter.xxx.name
    },
  ]

  ecs_execution_role_arn = "arn:aws:iam:abc"
  ecs_security_group_ids = ["sg-aaa", "sg-bbb"]
  ecs_subnet_ids         = ["subnet-aaa", "subnet-bbb"]
  ecs_task_role_arn      = "arn:aws:iam:xyz"
  lb_access_log_bucket   = "S3 bucket name"
  lb_certificate_arn     = "arn:aws:acm:xyz"
  lb_security_groups     = ["sg-ccc", "sg-ddd"]
  lb_subnets             = ["subnet-ccc", "subnet-ddd"]
  prefix                 = "any string"
  vpc_id                 = "vpc-xxx"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db_create_container_definition"></a> [db\_create\_container\_definition](#module\_db\_create\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |
| <a name="module_db_migrate_container_definition"></a> [db\_migrate\_container\_definition](#module\_db\_migrate\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |
| <a name="module_db_upgrade_container_definition"></a> [db\_upgrade\_container\_definition](#module\_db\_upgrade\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |
| <a name="module_scheduler_container_definition"></a> [scheduler\_container\_definition](#module\_scheduler\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |
| <a name="module_server_container_definitions"></a> [server\_container\_definitions](#module\_server\_container\_definitions) | cloudposse/ecs-container-definition/aws | 0.58.1 |
| <a name="module_worker_container_definition"></a> [worker\_container\_definition](#module\_worker\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.redash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.db_create](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.db_migrate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.db_upgrade](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb.redash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.redash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_environments"></a> [container\_environments](#input\_container\_environments) | The environments to set to each ECS container | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | n/a | yes |
| <a name="input_container_image_url"></a> [container\_image\_url](#input\_container\_image\_url) | The URL of the image used to launch the container. Images in the Docker Hub registry available by default | `string` | n/a | yes |
| <a name="input_container_secrets"></a> [container\_secrets](#input\_container\_secrets) | The secrets to set to each ECS container | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | n/a | yes |
| <a name="input_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#input\_ecs\_execution\_role\_arn) | The ARN of ECS execution role | `string` | n/a | yes |
| <a name="input_ecs_security_group_ids"></a> [ecs\_security\_group\_ids](#input\_ecs\_security\_group\_ids) | The list of security group IDs to assign to the ECS task or service | `list(string)` | n/a | yes |
| <a name="input_ecs_subnet_ids"></a> [ecs\_subnet\_ids](#input\_ecs\_subnet\_ids) | The list of subnet IDs to assign to the ECS task or service | `list(string)` | n/a | yes |
| <a name="input_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#input\_ecs\_task\_role\_arn) | The ARN of the ECS task role | `string` | n/a | yes |
| <a name="input_lb_certificate_arn"></a> [lb\_certificate\_arn](#input\_lb\_certificate\_arn) | The ARN of the default SSL server certificate | `string` | n/a | yes |
| <a name="input_lb_security_groups"></a> [lb\_security\_groups](#input\_lb\_security\_groups) | The list of security group IDs to assign to the LB | `list(string)` | n/a | yes |
| <a name="input_lb_subnets"></a> [lb\_subnets](#input\_lb\_subnets) | The list of subnet IDs to attach to the LB | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of VPC where the load balancer is installed | `string` | n/a | yes |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | If true, Public IP is assigned to ECS service | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | The number of days you want to retain log events | `number` | `90` | no |
| <a name="input_db_container_cpu"></a> [db\_container\_cpu](#input\_db\_container\_cpu) | The number of cpu units to reserve for the container which is used to kick the DB tasks | `number` | `512` | no |
| <a name="input_db_container_memory"></a> [db\_container\_memory](#input\_db\_container\_memory) | The amount of memory (in MiB) to allow the container to use the DB tasks | `number` | `1024` | no |
| <a name="input_lb_access_log_bucket"></a> [lb\_access\_log\_bucket](#input\_lb\_access\_log\_bucket) | The S3 bucket name to store the logs in | `string` | `null` | no |
| <a name="input_lb_access_log_prefix"></a> [lb\_access\_log\_prefix](#input\_lb\_access\_log\_prefix) | The prefix (logical hierarchy) in the access log bucket, the logs are placed the `LB_NAME/` if not configured | `string` | `null` | no |
| <a name="input_lb_ssl_policy"></a> [lb\_ssl\_policy](#input\_lb\_ssl\_policy) | The name of the SSL Policy for the listener | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix for the resource names | `string` | `null` | no |
| <a name="input_scheduler_container_cpu"></a> [scheduler\_container\_cpu](#input\_scheduler\_container\_cpu) | The number of cpu units to reserve for the scheduler container | `number` | `1024` | no |
| <a name="input_scheduler_container_memory"></a> [scheduler\_container\_memory](#input\_scheduler\_container\_memory) | The amount of memory (in MiB) to allow the scheduler container | `number` | `2048` | no |
| <a name="input_server_container_cpu"></a> [server\_container\_cpu](#input\_server\_container\_cpu) | The number of cpu units to reserve for the server container | `number` | `1024` | no |
| <a name="input_server_container_memory"></a> [server\_container\_memory](#input\_server\_container\_memory) | The amount of memory (in MiB) to allow the server container | `number` | `2048` | no |
| <a name="input_server_desired_count"></a> [server\_desired\_count](#input\_server\_desired\_count) | The number of redash server tasks | `number` | `1` | no |
| <a name="input_worker_container_cpu"></a> [worker\_container\_cpu](#input\_worker\_container\_cpu) | The number of cpu units to reserve for the worker container | `number` | `1024` | no |
| <a name="input_worker_container_memory"></a> [worker\_container\_memory](#input\_worker\_container\_memory) | The amount of memory (in MiB) to allow the worker container | `number` | `2048` | no |
| <a name="input_worker_desired_count"></a> [worker\_desired\_count](#input\_worker\_desired\_count) | The number of redash worker tasks | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The ARN of LB |
| <a name="output_lb_dns"></a> [lb\_dns](#output\_lb\_dns) | The DNS name of LB |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The Zone ID of LB |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
