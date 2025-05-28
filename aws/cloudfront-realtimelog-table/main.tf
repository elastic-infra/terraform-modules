/**
* ## Information
*
* Athena table for CloudFront realtime log
*
* ### Usage
*
* ```hcl
* resource "aws_glue_catalog_database" "cf_realtimelog" {
*   name = "cf_realtimelog"
* }
*
* module "cf_realtimelog_table" {
*   source = "github.com/elastic-infra/terraform-modules//aws/cloudfront-realtimelog-table"
*
*   name          = "api"
*   database_name = aws_glue_catalog_database.cf_realtimelog.name
*   location      = "s3://cloudfront-realtimelog/api"
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

    "skip.header.line.count"       = 2
    "projection.enabled"           = "true"
    "projection.day.type"          = "date"
    "projection.day.range"         = var.partition_range
    "projection.day.format"        = "yyyy/MM/dd"
    "projection.day.interval"      = 1
    "projection.day.interval.unit" = "DAYS"
    "projection.hour.type"         = "integer"
    "projection.hour.range"        = "0,23"
    "projection.hour.digits"       = "2"
    "storage.location.template"    = "${var.location}/$${day}/$${hour}/"
  }

  storage_descriptor {
    location      = var.location
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "field.delim" = "\t"
      }
    }

    # NOTE: https://docs.aws.amazon.com/athena/latest/ug/create-cloudfront-table-real-time-logs.html
    columns {
      name = "timestamp"
      type = "string"
    }

    columns {
      name = "c_ip"
      type = "string"
    }

    columns {
      name = "time_to_first_byte"
      type = "bigint"
    }

    columns {
      name = "sc_status"
      type = "bigint"
    }

    columns {
      name = "sc_bytes"
      type = "bigint"
    }

    columns {
      name = "cs_method"
      type = "string"
    }

    columns {
      name = "cs_protocol"
      type = "string"
    }

    columns {
      name = "cs_host"
      type = "string"
    }

    columns {
      name = "cs_uri_stem"
      type = "string"
    }

    columns {
      name = "cs_bytes"
      type = "bigint"
    }

    columns {
      name = "x_edge_location"
      type = "string"
    }

    columns {
      name = "x_edge_request_id"
      type = "string"
    }

    columns {
      name = "x_host_header"
      type = "string"
    }

    columns {
      name = "time_taken"
      type = "bigint"
    }

    columns {
      name = "cs_protocol_version"
      type = "string"
    }

    columns {
      name = "c_ip_version"
      type = "string"
    }

    columns {
      name = "cs_user_agent"
      type = "string"
    }

    columns {
      name = "cs_referer"
      type = "string"
    }

    columns {
      name = "cs_cookie"
      type = "string"
    }

    columns {
      name = "cs_uri_query"
      type = "string"
    }

    columns {
      name = "x_edge_response_result_type"
      type = "string"
    }

    columns {
      name = "x_forwarded_for"
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
      name = "x_edge_result_type"
      type = "string"
    }

    columns {
      name = "fle_encrypted_fields"
      type = "string"
    }

    columns {
      name = "fle_status"
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
      type = "string"
    }

    columns {
      name = "sc_range_end"
      type = "string"
    }

    columns {
      name = "c_port"
      type = "bigint"
    }

    columns {
      name = "x_edge_detailed_result_type"
      type = "string"
    }

    columns {
      name = "c_country"
      type = "string"
    }

    columns {
      name = "cs_accept_encoding"
      type = "string"
    }

    columns {
      name = "cs_accept"
      type = "string"
    }

    columns {
      name = "cache_behavior_path_pattern"
      type = "string"
    }

    columns {
      name = "cs_headers"
      type = "string"
    }

    columns {
      name = "cs_header_names"
      type = "string"
    }

    columns {
      name = "cs_headers_count"
      type = "bigint"
    }

    columns {
      name = "primary_distribution_id"
      type = "string"
    }

    columns {
      name = "primary_distribution_dns_name"
      type = "string"
    }

    columns {
      name = "origin_fbl"
      type = "string"
    }

    columns {
      name = "origin_lbl"
      type = "string"
    }

    columns {
      name = "asn"
      type = "string"
    }
  }

  partition_keys {
    name = "day"
    type = "string"
  }

  partition_keys {
    name = "hour"
    type = "int"
  }
}
