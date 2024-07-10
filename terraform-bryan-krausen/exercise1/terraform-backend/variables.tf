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


variable "zone" {
  type        = string
  description = "For aws zone"
  default     = "eu-north-1b"
}