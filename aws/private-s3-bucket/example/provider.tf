provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Owner = "ei-terraform-modules"
      Usage = "test"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
