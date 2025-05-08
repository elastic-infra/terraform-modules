/**
* ## Information
*
* Athena table for VPC flow log
*
* ### Usage
*
* ```hcl
* module "main" {
*   source = "github.com/elastic-infra/terraform-modules//aws/flow-log-table?ref=vX.Y.Z"
*
*   name          = "main"
*   database_name = "flowlog"
*   location      = "s3://${aws_s3_bucket.log.id}/AWSLogs/${data.aws_caller_identity.self.account_id}/vpcflowlogs/${var.region}"
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

    "skip.header.line.count" = 1
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
        "field.delim" = " "
      }
    }

    dynamic "columns" {
      for_each = local.columns_for_versions[var.log_format_version]
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
