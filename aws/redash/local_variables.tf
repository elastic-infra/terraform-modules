locals {
  base_name = var.prefix ? "${var.prefix}-redash" : "redash"

  container_names = {
    server     = var.prefix ? "${var.prefix}-redash-server" : "redash-server"
    worker     = var.prefix ? "${var.prefix}-redash-worker" : "redash-worker"
    db_migrate = var.prefix ? "${var.prefix}-redash-db-migrate" : "redash-db-migrate"
    db_upgrate = var.prefix ? "${var.prefix}-redash-db-upgrade" : "redash-db-upgrade"
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
