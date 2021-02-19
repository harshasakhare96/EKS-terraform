provider "aws" {
  version = ">= 2.28.1"
  region  = "ap-southeast-1"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "gw-test-terraform-state"
    key = "gw-test-infra/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
