<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create Redash ECS cluster and its Application load balancer.

### Prerequisite

N/A

### Usage

```hcl
module "redash" {
  source = "github.com/elastic-infra/terraform-modules//aws/redash?ref=v1.4.0"

  container_image_url = "redash/redash:8.0.2.b37747"

  container_environments = [
    {
      name   = "(Environment variable name)"
      value  = "(plain string)"
    },
  ]

  container_secrets = [
    {
      name   = "(Secret environment variable name)"
      value  = aws_ssm_parameter.xxx.name
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
| terraform | ~> 0.12.2 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_logs\_retention\_in\_days | The number of days you want to retain log events | `number` | `90` | no |
| container\_environments | The environments to set to each ECS container | `list` | n/a | yes |
| container\_image\_url | The URL of the image used to launch the container. Images in the Docker Hub registry available by default | `string` | n/a | yes |
| container\_secrets | The secrets to set to each ECS container | `list` | n/a | yes |
| db\_container\_cpu | The number of cpu units to reserve for the container which is used to kick the DB tasks | `number` | `512` | no |
| db\_container\_memory | The amount of memory (in MiB) to allow the container to use the DB tasks | `number` | `1024` | no |
| ecs\_execution\_role\_arn | The ARN of ECS execution role | `string` | n/a | yes |
| ecs\_security\_group\_ids | The list of security group IDs to assign to the ECS task or service | `list` | n/a | yes |
| ecs\_subnet\_ids | The list of subnet IDs to assign to the ECS task or service | `list` | n/a | yes |
| ecs\_task\_role\_arn | The ARN of the ECS task role | `string` | n/a | yes |
| lb\_access\_log\_bucket | The S3 bucket name to store the logs in | `string` | `null` | no |
| lb\_certificate\_arn | The ARN of the default SSL server certificate | `string` | n/a | yes |
| lb\_security\_groups | The list of security group IDs to assign to the LB | `list` | n/a | yes |
| lb\_ssl\_policy | The name of the SSL Policy for the listener | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| lb\_subnets | The list of subnet IDs to attach to the LB | `list` | n/a | yes |
| prefix | A prefix for the resource names | `string` | `""` | no |
| server\_container\_cpu | The number of cpu units to reserve for the server container | `number` | `1024` | no |
| server\_container\_memory | The amount of memory (in MiB) to allow the server container | `number` | `2048` | no |
| server\_desired\_count | The number of redash server tasks | `number` | `1` | no |
| vpc\_id | The ID of VPC where the load balancer is installed | `string` | n/a | yes |
| worker\_container\_cpu | The number of cpu units to reserve for the worker container | `number` | `1024` | no |
| worker\_container\_memory | The amount of memory (in MiB) to allow the worker container | `number` | `2048` | no |
| worker\_desired\_count | The number of redash worker tasks | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| lb\_dns | The DNS name of LB |
| lb\_zone\_id | The Zone ID of LB |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
