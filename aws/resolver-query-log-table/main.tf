/**
* ## Information
*
* Athena table for Route 53 Resolver query log
*
* Query logs are delivered as gzip-compressed JSON objects under
* `AWSLogs/<account-id>/vpcdnsquerylogs/<vpc-id>/YYYY/MM/DD/`. The last
* segment of `location` must be the target VPC id, so create one table
* per VPC.
*
* ### Usage
*
* ```hcl
* module "main" {
*   source = "github.com/elastic-infra/terraform-modules//aws/resolver-query-log-table?ref=vX.Y.Z"
*
*   name          = "main"
*   database_name = "resolverquerylog"
*   location      = "s3://${aws_s3_bucket.log.id}/AWSLogs/${data.aws_caller_identity.self.account_id}/vpcdnsquerylogs/${var.vpc_id}"
* }
* ```
*
*/

resource "aws_glue_catalog_table" "t" {
  name          = var.name
  database_name = var.database_name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL       = "TRUE"
    classification = "json"
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
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "ignore.malformed.json" = "true"
      }
    }

    columns {
      name = "version"
      type = "string"
    }

    columns {
      name = "account_id"
      type = "string"
    }

    columns {
      name = "region"
      type = "string"
    }

    columns {
      name = "vpc_id"
      type = "string"
    }

    columns {
      name = "query_timestamp"
      type = "string"
    }

    columns {
      name = "query_name"
      type = "string"
    }

    columns {
      name = "query_type"
      type = "string"
    }

    columns {
      name = "query_class"
      type = "string"
    }

    columns {
      name = "rcode"
      type = "string"
    }

    columns {
      name = "answers"
      type = "array<struct<Rdata:string,Type:string,Class:string>>"
    }

    columns {
      name = "srcaddr"
      type = "string"
    }

    columns {
      name = "srcport"
      type = "int"
    }

    columns {
      name = "transport"
      type = "string"
    }

    columns {
      name = "srcids"
      type = "struct<instance:string,resolver_endpoint:string,resolver_network_interface:string>"
    }

    columns {
      name = "firewall_rule_group_id"
      type = "string"
    }

    columns {
      name = "firewall_rule_action"
      type = "string"
    }

    columns {
      name = "firewall_domain_list_id"
      type = "string"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
