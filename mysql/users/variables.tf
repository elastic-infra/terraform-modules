variable "users" {
  description = "Specify mysql users and grants. The key is the user name, and value is the password and grants."
  type = map(object({
    host                = optional(string, "%")
    password            = optional(string)
    password_wo         = optional(string)
    password_wo_version = optional(number)
    tls_option          = optional(string)
    auth_plugin         = optional(string)
    privileges          = map(list(string))
    roles               = optional(list(string), [])
    default_roles       = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.users :
      !(v.password != null && v.password_wo != null)
    ])
    error_message = "Each user must not have both 'password' and 'password_wo' set. Use one or the other."
  }
}
