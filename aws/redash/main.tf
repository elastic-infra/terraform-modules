/**
* ## Information
*
* Create Redash ECS cluster and its Application load balancer.
*
* ### Prerequisite
*
* N/A
*
* ### Usage
*
* ```hcl
* module "redash" {
*   source = "github.com/elastic-infra/terraform-modules//aws/redash?ref=v3.4.0"
*
*   container_image_url = "redash/redash:10.1.0.b50633"
*
*   container_environments = [
*     {
*       name   = "(Environment variable name)"
*       value  = "(plain string)"
*     },
*   ]
*
*   container_secrets = [
*     {
*       name      = "(Secret environment variable name)"
*       valueFrom = aws_ssm_parameter.xxx.name
*     },
*   ]
*
*   ecs_execution_role_arn = "arn:aws:iam:abc"
*   ecs_security_group_ids = ["sg-aaa", "sg-bbb"]
*   ecs_subnet_ids         = ["subnet-aaa", "subnet-bbb"]
*   ecs_task_role_arn      = "arn:aws:iam:xyz"
*   lb_access_log_bucket   = "S3 bucket name"
*   lb_certificate_arn     = "arn:aws:acm:xyz"
*   lb_security_groups     = ["sg-ccc", "sg-ddd"]
*   lb_subnets             = ["subnet-ccc", "subnet-ddd"]
*   prefix                 = "any string"
*   vpc_id                 = "vpc-xxx"
* }
* ```
*
* ### Standalone scheduler (Redash v10+)
*
* By default the scheduler runs as an extra container co-located in the worker task.
* Set `standalone_scheduler = true` to run it as its own dedicated ECS service instead.
*
* **Migrating an existing deployment**: flipping `standalone_scheduler` from `false` to
* `true` removes the scheduler container from the worker task while the new standalone
* scheduler service starts up. During the worker's rolling deployment the old worker task
* (still running the scheduler) and the new scheduler service can run at the same time, so
* `rq_scheduler` may briefly run as two instances. Since `rq_scheduler` must be a singleton,
* jobs can be double-scheduled in that window. To avoid it, apply in two steps: first scale
* the worker down (or otherwise stop the co-located scheduler), then enable
* `standalone_scheduler`.
*
*/
