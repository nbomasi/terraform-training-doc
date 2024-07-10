variable "REGION" {
  default = "eu-north-1"
}

variable "ZONE1" {
  default = "eu-north-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    eu-north-1 = "ami-0705384c0b33c194c"
    us-east-1 = "ami-0947d2ba12ee1ff75"
  }
}

variable "SG" {
  default = "sg-07d958d8fdcf16249"
}