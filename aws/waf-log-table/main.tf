/**
* ## Information
*
* Athena table for WAF log
*
* ### Usage
*
* ```hcl
* module "main" {
*   source = "github.com/elastic-infra/terraform-modules//aws/waf-log-table?ref=v2.4.0"
*
*   name          = "main"
*   database_name = "waflog"
*   location      = "s3://athenawaflogs/WebACL/"
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
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"

      parameters = {
        # NOTE: https://docs.aws.amazon.com/athena/latest/ug/waf-logs.html
        "paths" = "action,formatVersion,httpRequest,httpSourceId,httpSourceName,nonTerminatingMatchingRules,rateBasedRuleList,ruleGroupList,terminatingRuleId,terminatingRuleMatchDetails,terminatingRuleType,timestamp,webaclId"
      }
    }

    columns {
      name = "timestamp"
      type = "bigint"
    }

    columns {
      name = "formatversion"
      type = "int"
    }

    columns {
      name = "webaclid"
      type = "string"
    }

    columns {
      name = "terminatingruleid"
      type = "string"
    }

    columns {
      name = "terminatingruletype"
      type = "string"
    }

    columns {
      name = "action"
      type = "string"
    }

    columns {
      name = "terminatingrulematchdetails"
      type = "array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>"
    }

    columns {
      name = "httpsourcename"
      type = "string"
    }

    columns {
      name = "httpsourceid"
      type = "string"
    }

    columns {
      name = "rulegrouplist"
      type = "array<struct<rulegroupid:string,terminatingrule:struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>,nonterminatingmatchingrules:array<struct<ruleid:string,action:string,overriddenaction:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>,excludedrules:string>>"
    }

    columns {
      name = "ratebasedrulelist"
      type = "array<struct<ratebasedruleid:string,limitkey:string,maxrateallowed:int>>"
    }

    columns {
      name = "nonterminatingmatchingrules"
      type = "array<struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>,challengeresponse:struct<responsecode:string,solvetimestamp:string>,captcharesponse:struct<responsecode:string,solvetimestamp:string>>>"
    }

    columns {
      name = "requestheadersinserted"
      type = "array<struct<name:string,value:string>>"
    }

    columns {
      name = "responsecodesent"
      type = "string"
    }

    columns {
      name = "httprequest"
      type = "struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string>"
    }

    columns {
      name = "labels"
      type = "array<struct<name:string>>"
    }

    columns {
      name = "captcharesponse"
      type = "struct<responsecode:string,solvetimestamp:string,failureReason:string>"
    }

    columns {
      name = "challengeresponse"
      type = "struct<responsecode:string,solvetimestamp:string,failureReason:string>"
    }

    columns {
      name = "ja3fingerprint"
      type = "string"
    }

    columns {
      name = "oversizefields"
      type = "string"
    }

    columns {
      name = "requestbodysize"
      type = "int"
    }

    columns {
      name = "requestbodysizeinspectedbywaf"
      type = "int"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }
}
