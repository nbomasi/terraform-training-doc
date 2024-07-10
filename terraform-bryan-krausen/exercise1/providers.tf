## Installing different terraform providers

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.54.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "aws" {
   region = var.aws_region
   
 }
 
# We use the following command to redirect the state file: syntax terraform init -migrate-state
# terraform {
#   backend "local" {
#     path = "boma-state/terraform.tfstate"
#   }
# }

# Terraform remote backend
# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "Smile-Nigeria-Limited"

#     workspaces {
#       name = "boma-prod"
#     }
#   }
# }

# Explanations on provider

# Inline Provider Configuration: Simple and straightforward for single-provider setups. Does not include version or source specifications.

# provider "aws" {
#   region = "us-west-2"
# }

# required_providers Block: Adds the ability to specify the provider's version and source, offering more control and stability for the configuration.

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.54.1"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }

# Provider Aliases: Useful for complex configurations requiring multiple instances of the same provider with different settings

# provider "aws" {
#   alias  = "us_west"
#   region = "us-west-2"
# }

# provider "aws" {
#   alias  = "us_east"
#   region = "us-east-1"
# }

# resource "aws_instance" "west" {
#   provider = aws.us_west
#   # other configuration
# }

# resource "aws_instance" "east" {
#   provider = aws.us_east
#   # other configuration
# }

# DynamoDB addition to s3 backend makes  terraform state lock possible

# terraform {
#   backend "s3" {
#     bucket = "terraform-state"
#     key    = "terraform.tfstate"
#     region = "eu-north-1"
#     dynamodb_table = "terraform-state"
#     encrypt = true
#   }
# }

# Terraform 0.12.20 introduced a new backend "s3" which is the default backend for Terraform 0.12.20.
#   }
# }