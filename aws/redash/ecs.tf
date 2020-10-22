# ECS Cluster
resource "aws_ecs_cluster" "redash" {
  name = local.base_name
}

## Server
resource "aws_ecs_task_definition" "server" {
  family                   = local.container_names["server"]
  container_definitions    = module.server_container_definitions.json_map_encoded_list
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.server_container_cpu
  memory                   = var.server_container_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}

resource "aws_ecs_service" "server" {
  name                               = local.container_names["server"]
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.redash.id
  task_definition                    = aws_ecs_task_definition.server.arn
  desired_count                      = var.server_desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups  = var.ecs_security_group_ids
    subnets          = var.ecs_subnet_ids
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.redash.arn
    container_name   = local.container_names["server"]
    container_port   = 5000
  }

  depends_on = [
    aws_lb_listener.https,
  ]
}

## Worker
resource "aws_ecs_task_definition" "worker" {
  family                   = local.container_names["worker"]
  container_definitions    = module.worker_container_definition.json_map_encoded_list
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.worker_container_cpu
  memory                   = var.worker_container_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}

resource "aws_ecs_service" "worker" {
  name                               = local.container_names["worker"]
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.redash.id
  task_definition                    = aws_ecs_task_definition.worker.arn
  desired_count                      = var.worker_desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups  = var.ecs_security_group_ids
    subnets          = var.ecs_subnet_ids
    assign_public_ip = var.assign_public_ip
  }
}

## DB Create
resource "aws_ecs_task_definition" "db_create" {
  family                   = local.container_names["db_create"]
  container_definitions    = module.db_create_container_definition.json_map_encoded_list
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_container_cpu
  memory                   = var.db_container_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}

## DB Migrate
resource "aws_ecs_task_definition" "db_migrate" {
  family                   = local.container_names["db_migrate"]
  container_definitions    = module.db_migrate_container_definition.json_map_encoded_list
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_container_cpu
  memory                   = var.db_container_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}

## DB Upgrade
resource "aws_ecs_task_definition" "db_upgrade" {
  family                   = local.container_names["db_upgrade"]
  container_definitions    = module.db_upgrade_container_definition.json_map_encoded_list
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.db_container_cpu
  memory                   = var.db_container_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}
