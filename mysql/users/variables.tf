variable "users" {
  description = "Specify mysql users and grants. The key is the user name, and value is the password and grants."
  type = map(object({
    password   = string
    privileges = map(list(string))
    roles      = optional(list(string), [])
  }))
  default = {}
}
