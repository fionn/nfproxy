terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~>2.2"
    }
  }
  required_version = ">= 1"
}