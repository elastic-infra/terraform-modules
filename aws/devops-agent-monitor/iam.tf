data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  agent_space_role_name   = coalesce(var.agent_space_role_name, "DevOpsAgent-${var.agent_space_name}-Space")
  operator_role_name      = coalesce(var.operator_role_name, "DevOpsAgent-${var.agent_space_name}-WebappAdmin")
  agent_space_arn_pattern = "arn:aws:aidevops:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:agentspace/*"
}

data "aws_iam_policy_document" "agent_space_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.agent_space_arn_pattern]
    }
  }
}

resource "aws_iam_role" "agent_space" {
  name               = local.agent_space_role_name
  description        = "Role assumed by AWS DevOps Agent Agent Space"
  assume_role_policy = data.aws_iam_policy_document.agent_space_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachments_exclusive" "agent_space_managed" {
  role_name   = aws_iam_role.agent_space.name
  policy_arns = var.agent_space_managed_policy_arns
}

data "aws_iam_policy_document" "agent_space_inline" {
  statement {
    sid     = "AllowCreateServiceLinkedRoles"
    effect  = "Allow"
    actions = ["iam:CreateServiceLinkedRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/resource-explorer-2.amazonaws.com/AWSServiceRoleForResourceExplorer",
    ]
  }
}

resource "aws_iam_role_policy" "agent_space_inline" {
  name   = "AllowCreateServiceLinkedRoles"
  role   = aws_iam_role.agent_space.id
  policy = data.aws_iam_policy_document.agent_space_inline.json
}

resource "aws_iam_role_policies_exclusive" "agent_space_inline" {
  role_name    = aws_iam_role.agent_space.name
  policy_names = [aws_iam_role_policy.agent_space_inline.name]
}

data "aws_iam_policy_document" "operator_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.agent_space_arn_pattern]
    }
  }
}

resource "aws_iam_role" "operator" {
  name               = local.operator_role_name
  description        = "Role assumed by AWS DevOps Agent Operator App"
  assume_role_policy = data.aws_iam_policy_document.operator_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachments_exclusive" "operator_managed" {
  role_name   = aws_iam_role.operator.name
  policy_arns = var.operator_managed_policy_arns
}
