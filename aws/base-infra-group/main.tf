/**
* ## Information
*
* Basic IAM groups
*
* ### Usage
*
* ```hcl
* module "base_group" {
*   source = "github.com/elastic-infra/terraform-modules//aws/base-infra-group?ref=v1.3.0"
*
*   reader_group_name = "iam-reader"
*   system_group_name = "infra-system"
* }
* ```
*
*/

resource "aws_iam_group" "infra_system" {
  name = var.system_group_name
}

resource "aws_iam_group_policy_attachment" "infra_system" {
  group      = aws_iam_group.infra_system.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_group_policy" "infra_system_read" {
  name   = "read"
  group  = aws_iam_group.infra_system.name
  policy = data.aws_iam_policy_document.infra_system_read.json
}

data "aws_iam_policy_document" "infra_system_read" {
  statement {
    effect = "Allow"

    actions = [
      "cloudfront:GetDistribution",
      "dms:DescribeReplicationInstances",
      "docdb:DescribeDBInstances",
      "es:DescribeDomain",
      "memorydb:DescribeClusters",
      "wafv2:GetWebACL",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_group_policy" "infra_system_ami_manager" {
  name   = "ami-manager"
  group  = aws_iam_group.infra_system.name
  policy = data.aws_iam_policy_document.infra_system_ami_manager.json
}

data "aws_iam_policy_document" "infra_system_ami_manager" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*::snapshot/*",
      "arn:aws:ec2:*::image/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "arn:aws:ec2:*::snapshot/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateImage",
      "ec2:DeregisterImage",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "infra_system_partition_ctl" {
  count  = length(var.partition_ctl_s3_bucket) > 0 ? 1 : 0
  name   = "partition-ctl"
  group  = aws_iam_group.infra_system.name
  policy = data.aws_iam_policy_document.infra_system_partition_ctl.json
}

data "aws_s3_bucket" "infra_system_partition_ctl" {
  for_each = toset(var.partition_ctl_s3_bucket)
  bucket   = each.key
}

data "aws_iam_policy_document" "infra_system_partition_ctl" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = formatlist("%s/*", values(data.aws_s3_bucket.infra_system_partition_ctl)[*].arn)
  }
}

resource "aws_iam_group_policy" "infra_system_register_r53" {
  count  = var.use_register_r53 ? 1 : 0
  name   = "register-r53"
  group  = aws_iam_group.infra_system.name
  policy = data.aws_iam_policy_document.infra_system_register_r53.json
}

data "aws_iam_policy_document" "infra_system_register_r53" {
  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["*"]
  }
}
