terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  alias = "acm"
  region = "us-east-1"
}

provider "aws" {
  region = var.region
}

provider "github" {}
