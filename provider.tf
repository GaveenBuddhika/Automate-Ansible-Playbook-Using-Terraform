terraform {
  required_version = ">= 1.0.0"

  required_providers {
     null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "mit_test"
}