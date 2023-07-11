<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create mysql users with grants

### Usage

```hcl
resource "mysql_database" "db" {
  provider = mysql.main

  name                  = "example"
  default_character_set = "utf8mb4"
  default_collation     = "utf8mb4_general_ci"
}

module "main_users" {
  source = "github.com/elastic-infra/terraform-modules//mysql/users?ref=v6.2.0"

  users = {
    user1 = {
      password = data.aws_kms_secrets.db_user.plaintext["user1"]
      privileges = {
        mysql_database.db.name = ["ALL PRIVILEGES"]
        "*"                    = ["SESSION_VARIABLES_ADMIN"]
      }
      roles = ["AWS_LOAD_S3_ACCESS", "AWS_SELECT_S3_ACCESS"]
    }
    user2 = {
      password = data.aws_kms_secrets.db_user.plaintext["user2"]
      privileges = {
        "${mysql_database.db.name}.table1" = ["SELECT"]
      }
    }
  }

  providers = {
    mysql = mysql.main
  }
}
```

* `password` - The password for the user.
* `privileges` - The keys are targets to grant privileges on. You specify asterisk`*`, database name or `database.table`(join database name and table name with dot). The value is the list of privileges to grant to the user.
* `roles` - Only supported in MySQL 8 and above. A list of roles to grant to the user.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_mysql"></a> [mysql](#requirement\_mysql) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mysql"></a> [mysql](#provider\_mysql) | >= 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mysql_grant.privileges](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/grant) | resource |
| [mysql_grant.roles](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/grant) | resource |
| [mysql_user.users](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_users"></a> [users](#input\_users) | Specify mysql users and grants. The key is the user name, and value is the password and grants. | <pre>map(object({<br>    password   = string<br>    privileges = map(list(string))<br>    roles      = optional(list(string), [])<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
