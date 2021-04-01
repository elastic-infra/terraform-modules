# Server
module "server_container_definitions" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.56.0"

  container_name   = local.container_names["server"]
  container_image  = var.container_image_url
  container_cpu    = var.server_container_cpu
  container_memory = var.server_container_memory

  command       = local.commands["server"]
  port_mappings = local.port_mappings
  environment   = var.container_environments
  secrets       = var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null

    options = {
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-group"         = aws_cloudwatch_log_group.logs["server"].name
      "awslogs-stream-prefix" = "server"
    }
  }
}

# Worker
module "worker_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.56.0"

  container_name   = local.container_names["worker"]
  container_image  = var.container_image_url
  container_cpu    = var.worker_container_cpu
  container_memory = var.worker_container_memory
  command          = local.commands["worker"]
  environment      = var.container_environments
  secrets          = var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null

    options = {
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-group"         = aws_cloudwatch_log_group.logs["worker"].name
      "awslogs-stream-prefix" = "worker"
    }
  }
}

# DB Create
module "db_create_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.56.0"

  container_name   = local.container_names["db_create"]
  container_image  = var.container_image_url
  container_cpu    = var.db_container_cpu
  container_memory = var.db_container_memory
  command          = local.commands["db_create"]
  environment      = []
  secrets          = var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null

    options = {
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-group"         = aws_cloudwatch_log_group.logs["db_create"].name
      "awslogs-stream-prefix" = "db-create"
    }
  }
}

# DB Migrate
module "db_migrate_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.56.0"

  container_name   = local.container_names["db_migrate"]
  container_image  = var.container_image_url
  container_cpu    = var.db_container_cpu
  container_memory = var.db_container_memory
  command          = local.commands["db_migrate"]
  environment      = []
  secrets          = var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null

    options = {
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-group"         = aws_cloudwatch_log_group.logs["db_migrate"].name
      "awslogs-stream-prefix" = "db-migrate"
    }
  }
}

# DB Upgrade
module "db_upgrade_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.56.0"

  container_name   = local.container_names["db_upgrade"]
  container_image  = var.container_image_url
  container_cpu    = var.db_container_cpu
  container_memory = var.db_container_memory
  command          = local.commands["db_upgrade"]
  environment      = []
  secrets          = var.container_secrets

  log_configuration = {
    logDriver     = "awslogs"
    secretOptions = null

    options = {
      "awslogs-region"        = data.aws_region.current.name
      "awslogs-group"         = aws_cloudwatch_log_group.logs["db_upgrade"].name
      "awslogs-stream-prefix" = "db-upgrade"
    }
  }
}
