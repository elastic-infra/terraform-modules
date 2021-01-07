terraform {
  required_version = ">= 0.12.26, < 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}
