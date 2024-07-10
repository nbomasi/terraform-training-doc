
# locals {
#   Owner        = "team"
#   App          = "application"
#   service_name = "Automation"
#   app_team     = "Cloud Team"
#   createdby    = "terraform"

# }

# locals {
#   # Common tags to be assigned to all resources
#   common_tags = {
#     Owner     = local.Owner
#     App       = local.App
#     Service   = local.service_name
#     AppTeam   = local.app_team
#     CreatedBy = local.createdby
#   }
# }

# #Using local with resources
# resource "aws_instance" "intro" {
#   ami                    = "ami-0705384c0b33c194c"
#   instance_type          = var.instance_type
#   availability_zone      = var.zone
#   key_name               = "java_key"
#   vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
#   tags = {
#     Name        = "Dove-instance",
#     Environment = "dev"
#     "Service"   = local.service_name
#     "AppTeam"   = local.app_team
#     "CreatedBy" = local.createdby

#   }
# }

# #Using local with resources
# resource "aws_instance" "intro2" {
#   ami                    = "ami-0705384c0b33c194c"
#   instance_type          = "t3.micro"
#   availability_zone      = "eu-north-1b"
#   key_name               = "java_key"
#   vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
#   tags                   = local.common_tags

# }
data "vault_generic_secret" "phone_number" {
  path = "secret/app"
}

locals {
  contact_info = {
      cloud = var.cloud
      department = var.no_caps
      cost_code = var.character_limit
      phone_number = var.phone_number
  }

  my_number = nonsensitive(var.phone_number)
}

output "cloud" {
  value = local.contact_info.cloud
}

output "department" {
  value = local.contact_info.department
}

output "cost_code" {
  value = local.contact_info.cost_code
}

# output "phone_number" {
#   value = local.contact_info.phone_number
#   sensitive = true
# }

output "my_number" {
  value = local.my_number
}

# output "phone_number" {
#   value = data.vault_generic_secret.phone_number
#   sensitive = true
# }

# To get just the phone number
output "phone_number" {
  value = data.vault_generic_secret.phone_number.data["phone_number"]
  sensitive = true
}