locals {
  base_name = var.prefix == null ? "redash" : "${var.prefix}-redash"

  container_names = {
    server     = var.prefix == null ? "redash-server" : "${var.prefix}-redash-server"
    worker     = var.prefix == null ? "redash-worker" : "${var.prefix}-redash-worker"
    db_migrate = var.prefix == null ? "redash-db-migrate" : "${var.prefix}-redash-db-migrate"
    db_upgrade = var.prefix == null ? "redash-db-upgrade" : "${var.prefix}-redash-db-upgrade"
    db_upgrade = var.prefix == null ? "redash-db-create" : "${var.prefix}-redash-db-create"
  }

  commands = {
    server     = ["server"]
    worker     = ["scheduler"]
    db_migrate = ["manage", "db", "migrate"]
    db_upgrade = ["manage", "db", "upgrade"]
  }

  port_mappings = [
    {
      protocol      = "tcp"
      containerPort = 5000
      hostPort      = 5000
    },
  ]
}
