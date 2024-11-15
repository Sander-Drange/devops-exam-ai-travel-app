terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "50/terraform.tfstate"  # Bruker kandidatnummer 50
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}