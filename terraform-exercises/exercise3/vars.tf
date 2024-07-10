variable "REGION" {
  default = "eu-north-1"
}

variable "ZONE1" {
  default = "eu-north-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    eu-north-2 = "ami-0705384c0b33c194c"
    eu-north-1 = "ami-064983766e6ab3419"
  }
}

variable "SG" {
  default = "sg-07d958d8fdcf16249"
}

variable "USER" {
  default = "ec2-user"
}