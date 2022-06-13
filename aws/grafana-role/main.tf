/**
* ## Information
*
* Grafana monitoring role
*
* ### Usage
*
* ```hcl
* module "grafana-role" {
*   source = "github.com/elastic-infra/terraform-modules//aws/grafana-role?ref=v4.2.0"
*
*   prefix                  = "prefix"
*   athena_workgroups       = [aws_athena_workgroup.infra.arn]
*   athena_result_bucket    = module.athena_bucket.bucket_arn
*   athena_search_buckets   = [module.log_bucket.bucket_arn]
*   cwlogs_search_loggroups = [data.aws_cloudwatch_log_group.rds_slowquery.arn]
* }
* ```
*
*/
