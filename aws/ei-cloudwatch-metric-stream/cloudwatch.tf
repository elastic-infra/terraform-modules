data "aws_iam_policy_document" "cw_metric_stream" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]
    resources = [
      aws_kinesis_firehose_delivery_stream.cw_metric_stream.arn,
    ]
  }
}

module "cw_metric_stream_role" {
  source = "../iam-service-role"

  name = "cw-metric-stream-to-ei-${random_string.this.result}"
  trusted_services = [
    "streams.metrics.cloudwatch.amazonaws.com"
  ]

  role_inline_policies = [
    {
      name   = "SendToKinesis"
      policy = data.aws_iam_policy_document.cw_metric_stream.json
    },
  ]
}

resource "aws_cloudwatch_metric_stream" "to_ei" {
  name          = "to-ei-${random_string.this.result}"
  role_arn      = module.cw_metric_stream_role.role_arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.cw_metric_stream.arn
  output_format = "json"

  dynamic "include_filter" {
    for_each = toset(var.include_namespaces)

    content {
      namespace = include_filter.value
    }
  }
}
