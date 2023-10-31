locals {
  bastion = {
    ecs_name = "bastion"
  }
  network_configuration = jsonencode({
    awsvpcConfiguration = {
      assignPublicIp = "DISABLED"
      subnets        = var.ecs.subnets
      securityGroups = var.ecs.security_groups
    }
  })
  document_parameters = jsonencode({
    portNumber      = ["2020"]
    localPortNumber = ["10022"]
  })
  cluster_name = var.ecs.cluster == null ? aws_ecs_cluster.bastion[0].name : var.ecs.cluster
}

resource "aws_ecs_cluster" "bastion" {
  count = var.ecs.cluster == null ? 1 : 0

  name = "${var.prefix}-${local.bastion.ecs_name}"
}

module "bastion" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.60.1"

  container_name  = "bastion"
  container_image = "public.ecr.aws/elasticinfra/dante-fargate:latest"
}

module "timer" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.60.1"

  container_name  = "timer"
  container_image = "public.ecr.aws/amazonlinux/amazonlinux:2"
  command         = ["/usr/bin/sleep", var.timeout]
}

resource "aws_ecs_task_definition" "bastion" {
  family                = "${var.prefix}-${local.bastion.ecs_name}"
  container_definitions = "[${module.bastion.json_map_encoded},${module.timer.json_map_encoded}]"
  task_role_arn         = module.ecs_bastion_task_role.role_arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
}

data "aws_iam_policy_document" "ecs_bastion_task" {
  statement {
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*",
    ]
  }
}

module "ecs_bastion_task_role" {
  source = "../iam-service-role"

  name             = "${var.prefix}-bastion-ecs-task"
  trusted_services = ["ecs-tasks.amazonaws.com"]

  role_inline_policies = [
    {
      name   = "bastion-ecs-task"
      policy = data.aws_iam_policy_document.ecs_bastion_task.json
    },
  ]
}
