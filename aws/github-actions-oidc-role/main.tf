/**
* ## Information
*
* Create an IAM role that GitHub Actions can assume via OIDC (`sts:AssumeRoleWithWebIdentity`).
*
* ### Usage
*
* ```hcl
* resource "aws_iam_openid_connect_provider" "github_actions" {
*   url            = "https://token.actions.githubusercontent.com"
*   client_id_list = ["sts.amazonaws.com"]
* }
*
* data "aws_iam_policy_document" "example" {
*   statement {
*     effect    = "Allow"
*     actions   = ["ecr:GetAuthorizationToken"]
*     resources = ["*"]
*   }
* }
*
* module "example" {
*   source = "github.com/elastic-infra/terraform-modules//aws/github-actions-oidc-role?ref=v1.0.0"
*
*   name              = "example-github-actions"
*   oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
*
*   github_repositories = [
*     "repo:owner/repository:*",
*   ]
*
*   role_inline_policies = [
*     {
*       name   = "github-actions"
*       policy = data.aws_iam_policy_document.example.json
*     },
*   ]
* }
* ```
*
*/

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.github_repositories
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = var.oidc_audience
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.name
  path                 = var.role_path
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary

  tags = var.role_tags
}

resource "aws_iam_role_policy_attachments_exclusive" "this" {
  role_name   = aws_iam_role.this.name
  policy_arns = var.role_policy_arns
}

resource "aws_iam_role_policy" "this" {
  for_each = zipmap(var.role_inline_policies[*].name, var.role_inline_policies[*].policy)

  name   = each.key
  role   = aws_iam_role.this.name
  policy = each.value
}

resource "aws_iam_role_policies_exclusive" "this" {
  role_name    = aws_iam_role.this.name
  policy_names = keys(aws_iam_role_policy.this)
}
