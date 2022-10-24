<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Elastic Infra - CloudWatch Metic Steam Resource

### Usage

```hcl
module "ei_cloudwatch_metric_stream" {
  source         = "github.com/elastic-infra/terraform-modules//aws/ei-privatelink-consumer?ref=vX.Y.Z"
  ei_access_key  = "foo"
  s3_bucket_name = "barprod-cw-metic-stream-backup"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cw_metric_stream_role"></a> [cw\_metric\_stream\_role](#module\_cw\_metric\_stream\_role) | ../iam-service-role | n/a |
| <a name="module_kinesis_backup_bucket"></a> [kinesis\_backup\_bucket](#module\_kinesis\_backup\_bucket) | ../private-s3-bucket | n/a |
| <a name="module_kinesis_role"></a> [kinesis\_role](#module\_kinesis\_role) | ../iam-service-role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.kinesis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.kinesis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_cloudwatch_metric_stream.to_ei](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream) | resource |
| [aws_kinesis_firehose_delivery_stream.cw_metric_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.cw_metric_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kinesis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ei_access_key"></a> [ei\_access\_key](#input\_ei\_access\_key) | Access key for EI HTTP endpoint | `string` | n/a | yes |
| <a name="input_ei_http_endpoint"></a> [ei\_http\_endpoint](#input\_ei\_http\_endpoint) | The HTTP endpoint URL to which Kinesis Firehose sends data | `string` | `"https://cw-metric-stream.elastic-infra.com/v1"` | no |
| <a name="input_include_namespaces"></a> [include\_namespaces](#input\_include\_namespaces) | List of inclusive metric filters. See also https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html | `list(string)` | <pre>[<br>  "AWS/ELB",<br>  "AWS/RDS"<br>]</pre> | no |
| <a name="input_kinesis_http_buffer_interval"></a> [kinesis\_http\_buffer\_interval](#input\_kinesis\_http\_buffer\_interval) | Buffer incoming data for the specified period of time, in seconds, before delivering it to HTTP endpoint. | `number` | `60` | no |
| <a name="input_kinesis_http_buffer_size"></a> [kinesis\_http\_buffer\_size](#input\_kinesis\_http\_buffer\_size) | Buffer incoming data to the specified size, in MBs, before delivering it to HTTP endpoint. | `number` | `5` | no |
| <a name="input_kinesis_retry_duration"></a> [kinesis\_retry\_duration](#input\_kinesis\_retry\_duration) | Total amount of seconds Firehose spends on retries. | `number` | `7200` | no |
| <a name="input_kinesis_s3_buffer_interval"></a> [kinesis\_s3\_buffer\_interval](#input\_kinesis\_s3\_buffer\_interval) | Buffer incoming data for the specified period of time, in seconds, before delivering it to S3. | `number` | `300` | no |
| <a name="input_kinesis_s3_buffer_size"></a> [kinesis\_s3\_buffer\_size](#input\_kinesis\_s3\_buffer\_size) | Buffer incoming data to the specified size, in MBs, before delivering it to S3. | `number` | `5` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of S3 bucket for Kinesis backup configuration | `string` | `"cw-metric-stream-backup"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
