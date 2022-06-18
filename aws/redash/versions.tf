terraform {
  required_version = ">= 0.13, < 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2"
    }
  }
}
