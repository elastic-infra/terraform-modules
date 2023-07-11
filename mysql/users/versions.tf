terraform {
  required_version = ">= 1.3.0"
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = ">= 3"
    }
  }
}
