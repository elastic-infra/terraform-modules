/**
* ## Information
*
* Create a base-role for elastic-infra
*
* ### Usage
*
* ```hcl
* module "ei_base_role" {
*   source = "github.com/elastic-infra/terraform-modules//aws/ei-base-role?ref=v3.1.0"
*
*   prefix            = var.infra_env
*   additional_policy = data.aws_iam_policy_document.base.json
*   additional_policy_arns = [
*     aws_iam_policy.your_policy.arn,
*   ]
* }
* ```
*
*/

data "aws_iam_policy_document" "ec2_sts" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ei_base" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
    ]

    resources = [
      "arn:aws:dynamodb:*:*:table/ei-hosts",
      "arn:aws:dynamodb:*:*:table/ei-hosts/index/*",
    ]
  }
}

data "aws_iam_policy_document" "merged" {
  source_json   = data.aws_iam_policy_document.ei_base.json
  override_json = var.additional_policy
}

resource "aws_iam_role" "ei_base" {
  name               = "${var.prefix}-base"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_sts.json
}

resource "aws_iam_policy" "ei_base" {
  name   = "${var.prefix}-base"
  path   = "/"
  policy = data.aws_iam_policy_document.merged.json
}

resource "aws_iam_role_policy_attachment" "ei_base" {
  role       = aws_iam_role.ei_base.name
  policy_arn = aws_iam_policy.ei_base.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ei_base.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "additional_ei_base" {
  for_each = toset(var.additional_policy_arns)

  role       = aws_iam_role.ei_base.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ei_base" {
  name = "${var.prefix}-default-profile"
  role = aws_iam_role.ei_base.name
}
