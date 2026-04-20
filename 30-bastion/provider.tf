terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket         = "yellow-remote-123"
    key            = "expens-bastian"
    region         = "us-east-1"
    dynamodb_table = "yellow-locking-123"

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
