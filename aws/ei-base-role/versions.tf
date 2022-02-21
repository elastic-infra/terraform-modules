terraform {
  required_version = ">= 0.12.0, < 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2"
    }
  }
}
