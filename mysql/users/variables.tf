variable "users" {
  description = "Specify mysql users and grants. The key is the user name, and value is the password and grants."
  type = map(object({
    host          = optional(string, "%")
    password      = string
    tls_option    = optional(string)
    privileges    = map(list(string))
    roles         = optional(list(string), [])
    default_roles = optional(list(string), [])
  }))
  default = {}
}
