variable "instance_type" {
  type        = string
  description = "For my istance type"
  default     = "t3.micro"
}

variable "region" {
  type        = string
  description = "For my region"
  default     = "eu-north-1"
}

# variable "environment" {
#   type = string
#   default = "dev"
# }


variable "zone" {
  type        = string
  description = "For aws zone"
  default     = "eu-north-1b"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# variable "private_subnets" {
#   default = {
#     "private_subnet_1" = 0
#     "private_subnet_2" = 1
#     "private_subnet_3" = 2
#   }
# }

variable "public_subnets" {
  default = {
    "public_subnet_1" = 0
    "public_subnet_2" = 1
    "public_subnet_3" = 2
  }
}

# variable "variables_sub_cidr" {
#   description = "CIDR Block for the Variables Subnet"
#   type        = string
# }

variable "variables_sub_az" {
  description = "Availability Zone used Variables Subnet"
  type        = string
  default = "true"
}

variable "variables_sub_auto_ip" {
  description = "Set Automatic IP Assigment for Variables Subnet"
  type        = bool
  default = true
}

variable "variables_sub_cidr" {
  description = "CIDR Block for the Variables Subnet"
  type        = string
  default     = "10.0.202.0/24"
}

variable "variables_sub_az2" {
  description = "Availability Zone used for Variables Subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "variables_sub_auto_ip2" {
  description = "Set Automatic IP Assigment for Variables Subnet"
  type        = bool
  default     = true
}

variable "eu-north-1-azs" {
    type = list(string)
    default = [
        "eu-north-1a",
        "eu-north-1b",
        "eu-north-1c",
#         "eu-north-1d",
#         "eu-north-1e"
     ]
 }

variable "ip" {
  type = map(string)
  default = {
    prod = "10.0.170.0/24"
    dev  = "10.0.250.0/24"
  }
}

variable "num_1" {
  type = number
  description = "Numbers for function labs"
  default = 88
}

variable "num_2" {
  type = number
  description = "Numbers for function labs"
  default = 73
}

variable "num_3" {
  type = number
  description = "Numbers for function labs"
  default = 52
}

variable "environment" {
  type = string
  description = "Infrastructure environment. eg. dev, prod, etc"
  default = "test"
}