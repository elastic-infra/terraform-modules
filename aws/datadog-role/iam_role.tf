data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.datadog_aws_account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = var.external_ids
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.datadog_role_name
  description        = "Role for Datadog AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

moved {
  from = aws_iam_role.datadog_aws_integration
  to   = aws_iam_role.this
}

moved {
  from = aws_iam_policy.datadog_aws_integration
  to   = aws_iam_policy.this
}

moved {
  from = aws_iam_role_policy_attachments_exclusive.datadog_role
  to   = aws_iam_role_policy_attachments_exclusive.this
}

resource "aws_iam_role_policy_attachments_exclusive" "this" {
  role_name = aws_iam_role.this.name
  policy_arns = concat(
    [aws_iam_policy.this.arn],
    var.cspm_permissions ? ["arn:aws:iam::aws:policy/SecurityAudit"] : [],
    [for p in aws_iam_policy.extended : p.arn],
    var.additional_policy_arns,
  )
}
