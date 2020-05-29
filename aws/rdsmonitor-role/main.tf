/**
* ## Information
*
* RDS monitoring role
*
* ### Usage
*
* ```hcl
* module "rds-monitor-role" {
*   source = "github.com/elastic-infra/terraform-modules//aws/rdsmonitor-role?ref=v1.2.0"
*
*   role_name = "manaita-operator"
* }
* ```
*
*/

resource "aws_iam_role" "rds_monitor_role" {
  name               = var.role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.rdsmonitor-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "rds_monitor" {
  role       = aws_iam_role.rds_monitor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rdsmonitor-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
