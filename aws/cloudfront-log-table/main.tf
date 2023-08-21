/**
* ## Information
*
* Athena table for CloudFront log
*
* To use this module, the following application must be deployed and CloudFront logs must be partitioned.
*
* https://serverlessrepo.aws.amazon.com/applications/ap-northeast-1/089928438340/cloudfront-log-partition
*
* ### Usage
*
* ```hcl
* resource "aws_serverlessapplicationrepository_cloudformation_stack" "cloudfront_log_partition" {
*   name             = "cloudfront-log-partition"
*   application_id   = "arn:aws:serverlessrepo:ap-northeast-1:089928438340:applications/cloudfront-log-partition"
*   semantic_version = "1.1.0"
*
*   parameters = {
*     SourceBucket         = "cloudfront-log"
*     DestinationBucket    = "cloudfront-log"
*     DestinationKeyPrefix = "partitioned/"
*   }
*
*   capabilities = [
*     "CAPABILITY_IAM",
*     "CAPABILITY_RESOURCE_POLICY",
*   ]
* }
*
* resource "aws_s3_bucket_notification" "log" {
*   bucket = "cloudfront-log"
*
*   lambda_function {
*     lambda_function_arn = aws_serverlessapplicationrepository_cloudformation_stack.cloudfront_log_partition.outputs["FunctionArn"]
*     events              = ["s3:ObjectCreated:*"]
*     filter_prefix       = "main/"
*   }
* }
*
* module "main" {
*   source = "github.com/elastic-infra/terraform-modules//aws/cloudfront-log-table?ref=v6.3.0"
*
*   name          = "main"
*   database_name = "cflog"
*   location      = "s3://cloudfront-log/partitioned/main"
* }
* ```
*
*/

resource "aws_glue_catalog_table" "t" {
  name          = var.name
  database_name = var.database_name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"

    # CloudFront log has two lines header
    "skip.header.line.count" = 2
    # NOTE: https://docs.aws.amazon.com/athena/latest/ug/partition-projection.html
    "projection.enabled"            = true
    "projection.date.type"          = "date"
    "projection.date.range"         = var.partition_range
    "projection.date.format"        = "yyyy/MM/dd"
    "projection.date.interval"      = 1
    "projection.date.interval.unit" = "DAYS"
    "storage.location.template"     = "${var.location}/$${date}"
  }

  storage_descriptor {
    location      = var.location
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "field.delim"          = "\t"
        "serialization.format" = "\t"
      }
    }

    # NOTE: https://docs.aws.amazon.com/athena/latest/ug/cloudfront-logs.html
    columns {
      name = "log_date"
      type = "date"
    }

    columns {
      name = "time"
      type = "string"
    }

    columns {
      name = "location"
      type = "string"
    }

    columns {
      name = "bytes"
      type = "bigint"
    }

    columns {
      name = "request_ip"
      type = "string"
    }

    columns {
      name = "method"
      type = "string"
    }

    columns {
      name = "host"
      type = "string"
    }

    columns {
      name = "uri"
      type = "string"
    }

    columns {
      name = "status"
      type = "int"
    }

    columns {
      name = "referrer"
      type = "string"
    }

    columns {
      name = "user_agent"
      type = "string"
    }

    columns {
      name = "query_string"
      type = "string"
    }

    columns {
      name = "cookie"
      type = "string"
    }

    columns {
      name = "result_type"
      type = "string"
    }

    columns {
      name = "request_id"
      type = "string"
    }

    columns {
      name = "host_header"
      type = "string"
    }

    columns {
      name = "request_protocol"
      type = "string"
    }

    columns {
      name = "request_bytes"
      type = "bigint"
    }

    columns {
      name = "time_taken"
      type = "float"
    }

    columns {
      name = "xforwarded_for"
      type = "string"
    }

    columns {
      name = "ssl_protocol"
      type = "string"
    }

    columns {
      name = "ssl_cipher"
      type = "string"
    }

    columns {
      name = "response_result_type"
      type = "string"
    }

    columns {
      name = "http_version"
      type = "string"
    }

    columns {
      name = "fle_status"
      type = "string"
    }

    columns {
      name = "fle_encrypted_fields"
      type = "int"
    }

    columns {
      name = "c_port"
      type = "int"
    }

    columns {
      name = "time_to_first_byte"
      type = "float"
    }

    columns {
      name = "x_edge_detailed_result_type"
      type = "string"
    }

    columns {
      name = "sc_content_type"
      type = "string"
    }

    columns {
      name = "sc_content_len"
      type = "bigint"
    }

    columns {
      name = "sc_range_start"
      type = "bigint"
    }

    columns {
      name = "sc_range_end"
      type = "bigint"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
