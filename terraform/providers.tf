terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  required_version = ">= 1.2.0"
}

provider "docker" {}

provider "aws" {
  region = var.instance-region
}

