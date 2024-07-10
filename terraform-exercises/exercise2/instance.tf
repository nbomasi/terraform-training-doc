resource "aws_instance" "dove-inst" {
  ami                    = var.AMIS[var.REGION]
  #ami                    = "ami-0705384c0b33c194c"
  instance_type          = "t3.micro"
  availability_zone      = var.ZONE1
  key_name               = "java_key"
  #vpc_security_group_ids = ["sg-07d958d8fdcf16249"]
  vpc_security_group_ids = [var.SG]

  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }
}
