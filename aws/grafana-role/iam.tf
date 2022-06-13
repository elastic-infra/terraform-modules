data "aws_iam_policy_document" "grafana_sts" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.assumerole_principals
    }
  }
}

resource "aws_iam_role" "grafana" {
  name               = "${var.prefix}-grafana-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.grafana_sts.json
}

data "aws_iam_policy_document" "grafana" {
  # Athena
  ## https://docs.aws.amazon.com/ja_jp/athena/latest/ug/example-policies-workgroup.html
  dynamic "statement" {
    for_each = var.athena_result_bucket == null ? [] : [1]

    content {
      effect = "Allow"

      actions = [
        "glue:List*",
        "glue:Get*",
      ]

      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.athena_result_bucket == null ? [] : [1]

    content {
      effect = "Allow"

      actions = [
        "athena:ListEngineVersions",
        "athena:ListWorkGroups",
        "athena:ListDataCatalogs",
        "athena:ListDatabases",
        "athena:GetDatabase",
        "athena:ListTableMetadata",
        "athena:GetTableMetadata",
      ]

      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.athena_workgroups == [] ? [] : [1]

    content {
      effect = "Allow"

      actions = [
        "athena:GetWorkGroup",
        "athena:BatchGetQueryExecution",
        "athena:GetQueryExecution",
        "athena:ListQueryExecutions",
        "athena:StartQueryExecution",
        "athena:StopQueryExecution",
        "athena:GetQueryResults",
        "athena:GetQueryResultsStream",
        "athena:CreateNamedQuery",
        "athena:GetNamedQuery",
        "athena:BatchGetNamedQuery",
        "athena:ListNamedQueries",
        "athena:DeleteNamedQuery",
        "athena:CreatePreparedStatement",
        "athena:GetPreparedStatement",
        "athena:ListPreparedStatements",
        "athena:UpdatePreparedStatement",
        "athena:DeletePreparedStatement",
      ]

      resources = var.athena_workgroups
    }
  }

  dynamic "statement" {
    for_each = var.athena_result_bucket == null ? [] : [1]

    content {
      effect = "Allow"

      actions = [
        "s3:List*",
        "s3:Get*",
        "s3:Put*",
        "s3:AbortMultipartUpload",
      ]

      resources = [
        var.athena_result_bucket,
        "${var.athena_result_bucket}/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.athena_search_buckets == [] ? [] : [1]

    content {
      effect = "Allow"

      actions = [
        "s3:ListBucket",
        "s3:GetObject",
      ]

      resources = concat(
        var.athena_search_buckets,
        formatlist("%s/*", var.athena_search_buckets),
      )
    }
  }
}

resource "aws_iam_role_policy" "grafana" {
  name   = "grafana"
  role   = aws_iam_role.grafana.id
  policy = data.aws_iam_policy_document.grafana.json
}
