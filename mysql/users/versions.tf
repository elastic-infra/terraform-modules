terraform {
  required_version = ">= 1.11"
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = ">= 3.0.87"
    }
  }
}
