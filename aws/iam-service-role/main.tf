/**
* ## Information
*
* Create a Service Role
*
* ### Usage
*
* ```hcl
* module "service_role" {
*   source = "github.com/elastic-infra/terraform-modules//aws/iam-service-role?ref=v1.0.0"
*
*   name             = "role-name"
*   trusted_services = ["ec2.amazonaws.com"]
*   role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
*
*   create_instance_profile = true
* }
* ```
*
*/

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.trusted_services
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  path               = var.role_path
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  # Use for_each instead of count to prevent the reorder at recreated.
  for_each = toset(var.role_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "this" {
  for_each = zipmap(var.role_inline_policies[*].name, var.role_inline_policies[*].policy)

  name   = each.key
  role   = aws_iam_role.this.name
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.name
  path = var.role_path
  role = aws_iam_role.this.name
}
