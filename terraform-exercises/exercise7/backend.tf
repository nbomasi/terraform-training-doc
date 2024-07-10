terraform {
  backend "s3" {
    bucket = "boma-terraform--eun1-az1--x-s3"
    key    = "terraform/backend"
    region = "eu-north-1"
  }
}
