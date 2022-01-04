locals {
  base_name = var.prefix == null ? "redash" : "${var.prefix}-redash"

  container_names = merge({
    server     = var.prefix == null ? "redash-server" : "${var.prefix}-redash-server"
    worker     = var.prefix == null ? "redash-worker" : "${var.prefix}-redash-worker"
    db_create  = var.prefix == null ? "redash-db-create" : "${var.prefix}-redash-db-create"
    db_migrate = var.prefix == null ? "redash-db-migrate" : "${var.prefix}-redash-db-migrate"
    db_upgrade = var.prefix == null ? "redash-db-upgrade" : "${var.prefix}-redash-db-upgrade"
  }, local.redash_major_version >= 10 ? { scheduler = var.prefix == null ? "redash-scheduler" : "${var.prefix}-redash-scheduler" } : {})

  commands = {
    server     = ["server"]
    worker     = local.redash_major_version >= 10 ? ["worker"] : ["scheduler"]
    scheduler  = ["scheduler"]
    db_create  = ["create_db"]
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

  redash_major_version = split(".", split(":", var.container_image_url)[1])[0]
}
