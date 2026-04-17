variable "users" {
  description = "Specify mysql users and grants. The key is the user name, and value is the password and grants."
  type = map(object({
    host                = optional(string, "%")
    password            = optional(string)
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
      !(v.password != null && contains(keys(var.password_wo), k))
    ])
    error_message = "Each user must not have both 'password' and an entry in 'password_wo'. Use one or the other."
  }
}

variable "password_wo" {
  description = "Map of user names to write-only passwords. These are ephemeral and not stored in state."
  type        = map(string)
  default     = {}
  ephemeral   = true
}
