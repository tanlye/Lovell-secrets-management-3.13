
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0" # Choose an appropriate version for your configuration
    }
  }
  required_version = ">= 1.6"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

