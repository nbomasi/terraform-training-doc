output "public_ip" {
  description = "This is the public IP of my web server"
  value = aws_instance.intro.public_ip
}

output "ec2_instance_arn" {
  value = aws_instance.intro.arn
  sensitive = true
}

