variable "REGION" {
  default = "eu-north-1"
}

# variable "ZONE1" {
#   default = "us-east-2a"
# }

variable "AMIS" {
  type = map(any)
  default = {
    us-east-2  = "ami-064983766e6ab3419"
    eu-north-1 = "ami-064983766e6ab3419"
  }
}

variable "USER" {
  default = "ec2-user"
}