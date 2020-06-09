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

resource "aws_iam_group" "iam_reader" {
  name = var.reader_group_name
}

resource "aws_iam_group" "infra_system" {
  name = var.system_group_name
}

resource "aws_iam_group_policy_attachment" "iam_reader" {
  group      = aws_iam_group.iam_reader.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "system_poweruser" {
  group      = aws_iam_group.infra_system.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
