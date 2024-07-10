provider "aws" {
  region = "eu-north-1"
  # access_key_id = ""
  # secret_access_key = ""
}

resource "aws_instance" "intro" {
  ami                    = "ami-0705384c0b33c194c"
  instance_type          = "t3.micro"
  availability_zone      = "eu-north-1a"
  key_name               = "java_key"
  vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
  tags = {
    Name = "Dove-instance",
    Environment = "dev"
  }
}