provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
