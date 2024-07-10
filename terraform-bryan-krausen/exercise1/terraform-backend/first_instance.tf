
locals {
  Owner        = "team"
  App          = "application"
  service_name = "Automation"
  app_team     = "Cloud Team"
  createdby    = "terraform"

}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Owner     = local.Owner
    App       = local.App
    Service   = local.service_name
    AppTeam   = local.app_team
    CreatedBy = local.createdby
  }
}

#Using local with resources
resource "aws_instance" "intro" {
  ami                    = "ami-0705384c0b33c194c"
  instance_type          = var.instance_type
  availability_zone      = var.zone
  key_name               = "java_key"
  vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
  tags = {
    Name        = "Dove-instance",
    Environment = "dev"
    "Service"   = local.service_name
    "AppTeam"   = local.app_team
    "CreatedBy" = local.createdby

  }
}

#Using local with resources
resource "aws_instance" "intro2" {
  ami                    = "ami-0705384c0b33c194c"
  instance_type          = "t3.micro"
  availability_zone      = "eu-north-1b"
  key_name               = "java_key"
  vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
  tags                   = local.common_tags

}
