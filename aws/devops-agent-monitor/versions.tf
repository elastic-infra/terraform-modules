terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.29"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 1.66"
    }
  }
}
