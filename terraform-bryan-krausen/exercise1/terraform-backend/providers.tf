provider "aws" {
  region = var.region
  #   # access_key_id = ""
}

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "Smile-Nigeria-Limited"

#     workspaces {
#       name = "boma-prod"
#     }
#   }
# }

# terraform {
#   backend "s3" {
#     bucket = "boma-terraform--eun1-az1--x-s3"
#     key    = "backend"
#     region = "eu-north-1"
#   }
# }

# terraform {
#   backend "s3" {
#   }
# }