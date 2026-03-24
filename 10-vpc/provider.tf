terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.34.0"
    }
  }
  backend "s3" {
    bucket         = "yellow-remote-123"
    key            = "vpc-1"
    region         = "us-east-1"
    dynamodb_table = "yellow-locking-123"
  
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}