resource "aws_cloudwatch_log_group" "kinesis" {
  name              = "/aws/firehose/cw-metric-stream-to-ei-${random_string.this.result}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "kinesis" {
  log_group_name = aws_cloudwatch_log_group.kinesis.name
  name           = "to-ei"
}

data "aws_iam_policy_document" "kinesis" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [
      module.kinesis_backup_bucket.bucket_arn,
      "${module.kinesis_backup_bucket.bucket_arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = [
      aws_cloudwatch_log_stream.kinesis.arn,
    ]
  }
}

module "kinesis_role" {
  source = "../iam-service-role"

  name = "kinesis-cw-metric-stream-to-ei-${random_string.this.result}"
  trusted_services = [
    "firehose.amazonaws.com"
  ]

  role_inline_policies = [
    {
      name   = "BackupToS3"
      policy = data.aws_iam_policy_document.kinesis.json
    },
  ]
}

resource "aws_kinesis_firehose_delivery_stream" "cw_metric_stream" {
  name        = "cw-metric-stream-to-ei-${random_string.this.result}"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = module.kinesis_role.role_arn
    bucket_arn         = module.kinesis_backup_bucket.bucket_arn
    buffer_size        = var.kinesis_s3_buffer_size
    buffer_interval    = var.kinesis_s3_buffer_interval
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = var.ei_http_endpoint
    name               = "EI"
    access_key         = var.ei_access_key
    buffering_size     = var.kinesis_http_buffer_size
    buffering_interval = var.kinesis_http_buffer_interval
    role_arn           = module.kinesis_role.role_arn
    s3_backup_mode     = "FailedDataOnly"
    retry_duration     = var.kinesis_retry_duration

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis.name
    }
  }
}
