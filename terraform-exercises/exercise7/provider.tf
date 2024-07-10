terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.54.1"
      #region = var.REGION
    }

    local = {
      source  = "hashicorp/local"
      version = "~>2.1.0"
    }
  }
}