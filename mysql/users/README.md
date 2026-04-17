<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create mysql users with grants

### Usage with `password`

Password hash is stored in the state.

```hcl
module "main_users" {
  source = "github.com/elastic-infra/terraform-modules//mysql/users"

  users = {
    user1 = {
      password = data.aws_kms_secrets.db_user.plaintext["user1"]
      privileges = {
        mysql_database.db.name = ["ALL PRIVILEGES"]
        "*"                    = ["SESSION_VARIABLES_ADMIN"]
      }
      roles = ["AWS_LOAD_S3_ACCESS", "AWS_SELECT_S3_ACCESS"]
    }
  }

  providers = {
    mysql = mysql.main
  }
}
```

### Usage with `password_wo`

Password is not stored in the state. Requires Terraform v1.11+.
The `password_wo` variable is a separate ephemeral variable that accepts values from ephemeral resources.

```hcl
ephemeral "aws_kms_secrets" "db_user" {
  secret {
    name    = "user1"
    payload = "AQICAHg..."
  }
}

module "main_users" {
  source = "github.com/elastic-infra/terraform-modules//mysql/users"

  users = {
    user1 = {
      password_wo_version = 1
      privileges = {
        mysql_database.db.name = ["ALL PRIVILEGES"]
        "*"                    = ["SESSION_VARIABLES_ADMIN"]
      }
    }
  }

  password_wo = {
    user1 = ephemeral.aws_kms_secrets.db_user.plaintext["user1"]
  }

  providers = {
    mysql = mysql.main
  }
}
```

* `password` - The password for the user. The unsalted hash of the password is stored in the state.
* `password_wo` - A separate ephemeral variable. Map of user names to write-only passwords. Not stored in the state.
* `password_wo_version` - A version number to trigger password updates when using `password_wo`. Increment this to rotate the password.
* `privileges` - The keys are targets to grant privileges on. You specify asterisk`*`, database name or `database.table`(join database name and table name with dot). The value is the list of privileges to grant to the user.
* `roles` - Only supported in MySQL 8 and above. A list of roles to grant to the user.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_mysql"></a> [mysql](#requirement\_mysql) | >= 3.0.87 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mysql"></a> [mysql](#provider\_mysql) | 3.0.93 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [mysql_default_roles.default_roles](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/default_roles) | resource |
| [mysql_grant.privileges](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/grant) | resource |
| [mysql_grant.roles](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/grant) | resource |
| [mysql_user.users](https://registry.terraform.io/providers/petoju/mysql/latest/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_password_wo"></a> [password\_wo](#input\_password\_wo) | Map of user names to write-only passwords. These are ephemeral and not stored in state. | `map(string)` | `{}` | no |
| <a name="input_users"></a> [users](#input\_users) | Specify mysql users and grants. The key is the user name, and value is the password and grants. | <pre>map(object({<br/>    host                = optional(string, "%")<br/>    password            = optional(string)<br/>    password_wo_version = optional(number)<br/>    tls_option          = optional(string)<br/>    auth_plugin         = optional(string)<br/>    privileges          = map(list(string))<br/>    roles               = optional(list(string), [])<br/>    default_roles       = optional(list(string), [])<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
