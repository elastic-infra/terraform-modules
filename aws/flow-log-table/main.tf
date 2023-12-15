/**
* ## Information
*
* Athena table for VPC flow log
*
* ### Usage
*
* ```hcl
* module "main" {
*   source = "../module/aws/common/flow-log-table"
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

    columns {
      name = "version"
      type = "int"
    }

    columns {
      name = "account_id"
      type = "string"
    }

    columns {
      name = "interface_id"
      type = "string"
    }

    columns {
      name = "srcaddr"
      type = "string"
    }

    columns {
      name = "dstaddr"
      type = "string"
    }

    columns {
      name = "srcport"
      type = "int"
    }

    columns {
      name = "dstport"
      type = "int"
    }

    columns {
      name = "protocol"
      type = "bigint"
    }

    columns {
      name = "packets"
      type = "bigint"
    }

    columns {
      name = "bytes"
      type = "bigint"
    }

    columns {
      name = "start"
      type = "bigint"
    }

    columns {
      name = "end"
      type = "bigint"
    }

    columns {
      name = "action"
      type = "string"
    }

    columns {
      name = "log_status"
      type = "string"
    }

    columns {
      name = "vpc_id"
      type = "string"
    }

    columns {
      name = "subnet_id"
      type = "string"
    }

    columns {
      name = "instance_id"
      type = "string"
    }

    columns {
      name = "tcp_flags"
      type = "int"
    }

    columns {
      name = "type"
      type = "string"
    }

    columns {
      name = "pkt_srcaddr"
      type = "string"
    }

    columns {
      name = "pkt_dstaddr"
      type = "string"
    }

    columns {
      name = "region"
      type = "string"
    }

    columns {
      name = "az_id"
      type = "string"
    }

    columns {
      name = "sublocation_type"
      type = "string"
    }

    columns {
      name = "sublocation_id"
      type = "string"
    }

    columns {
      name = "pkt_src_aws_service"
      type = "string"
    }

    columns {
      name = "pkt_dst_aws_service"
      type = "string"
    }

    columns {
      name = "flow_direction"
      type = "string"
    }

    columns {
      name = "traffic_path"
      type = "int"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
