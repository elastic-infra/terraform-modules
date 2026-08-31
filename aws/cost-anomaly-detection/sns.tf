resource "aws_sns_topic" "this" {
  name              = var.sns.topic_name
  kms_master_key_id = var.sns.kms_master_key_id
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AWSAnomalyDetectionSNSPublishingPermissions"
    effect = "Allow"
    actions = [
      "sns:Publish",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    principals {
      type        = "Service"
      identifiers = ["costalerts.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.this.arn,
    ]
  }
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
