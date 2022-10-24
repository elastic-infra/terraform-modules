/**
* ## Information
* 
* Elastic Infra - CloudWatch Metic Steam Resource
* 
* ### Usage
* 
* ```hcl
* module "ei_cloudwatch_metric_stream" {
*   source         = "github.com/elastic-infra/terraform-modules//aws/ei-privatelink-consumer?ref=vX.Y.Z"
*   ei_access_key  = "foo"
*   s3_bucket_name = "barprod-cw-metic-stream-backup"
* }
* ```
*/

resource "random_string" "this" {
  length  = 8
  upper   = false
  special = false
}
