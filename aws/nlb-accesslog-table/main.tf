/**
* ## Information
*
* Athena table for Network Load Balancer access log
*
* ### Usage
*
* ```hcl
* module "main" {
*   source = "github.com/elastic-infra/terraform-modules//aws/nlb-accesslog-table?ref=v2.2.0"
*
*   name          = "main"
*   database_name = "accesslog"
*   location      = "s3://your_log_bucket/prefix/AWSLogs/<ACCOUNT-ID>/elasticloadbalancing/<REGION>"
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
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"

      parameters = {
        "serialization.format" = 1
        # NOTE: https://docs.aws.amazon.com/athena/latest/ug/networkloadbalancer-classic-logs.html
        "input.regex" = "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*):([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-0-9]*) ([-0-9]*) ([-0-9]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*)$"
      }
    }

    columns {
      name = "type"
      type = "string"
    }

    columns {
      name = "version"
      type = "string"
    }

    columns {
      name = "time"
      type = "string"
    }

    columns {
      name = "elb"
      type = "string"
    }

    columns {
      name = "listener_id"
      type = "string"
    }

    columns {
      name = "client_ip"
      type = "string"
    }

    columns {
      name = "client_port"
      type = "int"
    }

    columns {
      name = "target_ip"
      type = "string"
    }

    columns {
      name = "target_port"
      type = "int"
    }

    columns {
      name = "tcp_connection_time_ms"
      type = "double"
    }

    columns {
      name = "tls_handshake_time_ms"
      type = "double"
    }

    columns {
      name = "received_bytes"
      type = "bigint"
    }

    columns {
      name = "sent_bytes"
      type = "bigint"
    }

    columns {
      name = "incoming_tls_alert"
      type = "int"
    }

    columns {
      name = "cert_arn"
      type = "string"
    }

    columns {
      name = "certificate_serial"
      type = "string"
    }

    columns {
      name = "tls_cipher_suite"
      type = "string"
    }

    columns {
      name = "tls_protocol_version"
      type = "string"
    }

    columns {
      name = "tls_named_group"
      type = "string"
    }

    columns {
      name = "domain_name"
      type = "string"
    }

    columns {
      name = "alpn_fe_protocol"
      type = "string"
    }

    columns {
      name = "alpn_be_protocol"
      type = "string"
    }

    columns {
      name = "alpn_client_preference_list"
      type = "string"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
