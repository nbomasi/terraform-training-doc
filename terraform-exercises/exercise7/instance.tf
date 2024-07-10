provider "aws" {
  region = var.REGION
  default_tags {
    tags = {
      Environment = terraform.workspace
      ownner      = "Bomasi"
      Provsioned  = "Terraform"
    }
  }
}
resource "aws_key_pair" "boma-key" {
  key_name   = "boma-key"
  public_key = file("boma-key.pub")
}

resource "aws_instance" "dove-inst" {
  ami           = var.AMIS[var.REGION]
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.pub-sub1.id
  # availability_zone      = var.ZONE1

  key_name                    = aws_key_pair.boma-key.key_name
  vpc_security_group_ids      = [aws_security_group.boma-sg.id]
  associate_public_ip_address = true
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }

  connection {
    user        = var.USER
    private_key = file("boma-key")
    host        = self.public_ip
  }
  provisioner "file" {
    #source      = "cbn2.sh"
    source      = "cbn.sh"
    destination = "/tmp/cbn2.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/cbn2.sh",
      "ls -l /tmp",
      "pwd",
      "sudo /tmp/cbn2.sh"
    ]
  }
}

output "PublicIP" {
  value = aws_instance.dove-inst.public_ip
}

output "PrivateIP" {
  value = aws_instance.dove-inst.private_ip
}

resource "null_resource" "write_output" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.dove-inst.public_ip} > output.txt"
  }
}
# connection {
#   user        = var.USER
#   private_key = file("boma-key")
#   host        = self.public_ip
# }
# Using import command to import resources from Infrastrure Environment, note that the AMI and instance type are not part of the import command
# They were added manually after importing
# resource "aws_instance" "boma-ec2" {
#   ami                                  = "ami-0705384c0b33c194c"
#   instance_type                        = "t3.micro"


# }





