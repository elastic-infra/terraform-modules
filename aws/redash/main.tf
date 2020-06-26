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
*   source = "github.com/elastic-infra/terraform-modules//aws/redash?ref=v1.4.0"
*
*   container_image_url = "redash/redash:8.0.2.b37747"
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
*       name   = "(Secret environment variable name)"
*       value  = aws_ssm_parameter.xxx.name
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
*/
