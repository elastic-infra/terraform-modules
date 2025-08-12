/**
* ## Information
*
* Create mysql users with grants
*
* ### Usage
*
* ```hcl
* resource "mysql_database" "db" {
*   provider = mysql.main
*
*   name                  = "example"
*   default_character_set = "utf8mb4"
*   default_collation     = "utf8mb4_general_ci"
* }
*
* module "main_users" {
*   source = "github.com/elastic-infra/terraform-modules//mysql/users?ref=v6.2.0"
*
*   users = {
*     user1 = {
*       password = data.aws_kms_secrets.db_user.plaintext["user1"]
*       privileges = {
*         mysql_database.db.name = ["ALL PRIVILEGES"]
*         "*"                    = ["SESSION_VARIABLES_ADMIN"]
*       }
*       roles = ["AWS_LOAD_S3_ACCESS", "AWS_SELECT_S3_ACCESS"]
*     }
*     user2 = {
*       password = data.aws_kms_secrets.db_user.plaintext["user2"]
*       privileges = {
*         "${mysql_database.db.name}.table1" = ["SELECT"]
*       }
*     }
*   }
*
*   providers = {
*     mysql = mysql.main
*   }
* }
* ```
*
* * `password` - The password for the user.
* * `privileges` - The keys are targets to grant privileges on. You specify asterisk`*`, database name or `database.table`(join database name and table name with dot). The value is the list of privileges to grant to the user.
* * `roles` - Only supported in MySQL 8 and above. A list of roles to grant to the user.
*/

resource "mysql_user" "users" {
  for_each = var.users

  user               = each.key
  host               = each.value["host"]
  plaintext_password = each.value["password"]
  auth_plugin        = each.value["auth_plugin"]
  tls_option         = each.value["tls_option"]
}

locals {
  privileges = {
    for h in flatten([
      for k, v in var.users : [
        for target, priv in v["privileges"] : {
          key        = "${k}.${target}"
          user       = k
          database   = length(split(".", target)) == 1 ? target : split(".", target)[0]
          table      = length(split(".", target)) == 1 ? "*" : split(".", target)[1]
          privileges = priv
        }
      ]
    ]) : h["key"] => h
  }
  roles = {
    for k, v in var.users :
    k => v["roles"] if length(v["roles"]) > 0
  }
  default_roles = {
    for k, v in var.users :
    k => v["default_roles"] if length(v["default_roles"]) > 0
  }
}

resource "mysql_grant" "privileges" {
  for_each = local.privileges

  user       = mysql_user.users[each.value["user"]].user
  host       = mysql_user.users[each.value["user"]].host
  database   = each.value["database"]
  table      = each.value["table"]
  privileges = each.value["privileges"]
}

resource "mysql_grant" "roles" {
  for_each = local.roles

  user     = mysql_user.users[each.key].user
  host     = mysql_user.users[each.key].host
  database = ""
  roles    = each.value
}

resource "mysql_default_roles" "default_roles" {
  for_each = local.default_roles

  user  = mysql_user.users[each.key].user
  host  = mysql_user.users[each.key].host
  roles = each.value
}
