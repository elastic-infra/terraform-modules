data "aws_ecs_cluster" "this" {
  for_each = local.targets

  cluster_name = each.value.cluster_name
}

data "aws_ecs_service" "this" {
  for_each = local.targets

  service_name = each.value.service_name
  cluster_arn  = data.aws_ecs_cluster.this[each.key].arn
}

data "aws_iam_policy_document" "scheduler_reload_ecs" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:UpdateService",
    ]

    resources = values(data.aws_ecs_service.this)[*].arn
  }
}

module "scheduler_reload_ecs_role" {
  source = "github.com/elastic-infra/terraform-modules//aws/iam-service-role?ref=v9.1.0"

  name             = "${var.infra_env}-scheduler-reload-ecs"
  trusted_services = ["scheduler.amazonaws.com"]

  role_inline_policies = [
    {
      name   = "scheduler-reload-ecs"
      policy = data.aws_iam_policy_document.scheduler_reload_ecs.json
    },
  ]
}
