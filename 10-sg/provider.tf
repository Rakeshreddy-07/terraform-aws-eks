terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket         = "remote-state-devopsaws-dev"
    key            = "sg-dev" #key should always be uniuqe within the bucket, same key should not be used in other repos or tf providers
    region         = "us-east-1"
    dynamodb_table = "state-locking-devopsaws-dev"
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}