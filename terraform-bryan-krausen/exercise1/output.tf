# output "hello-world" {
#   description = "Print a Hello World text output"
#   value = "Hello World"
# }

# output "vpc_id" {
#   description = "Output the ID for the primary VPC"
#   value = aws_vpc.vpc.id
# }

# # output "public_url" {
# #   description = "Public URL for our Web Server"
# #   value = "https://${aws_instance.web_server.public_ip}:8080/index.html"
# # }

# output "vpc_information" {
#   description = "VPC Information about Environment"
#   value = "Your ${aws_vpc.vpc.tags.Environment} VPC has an ID of ${aws_vpc.vpc.id}"
# }

# output "vpc_zone" {
#   value = aws_subnet.list_subnet.availability_zone
# }

# output "vpc_subnet_list" {
#   value = aws_subnet.list_subnet.cidr_block
# }

# # Using loop iteration 
# # output "vpc_subnet_list_loop" {
# #   value = [aws_subnet.list_subnet_loop[each.key]]
# # }

# output "vpc_subnet_list_loop" {
#   value = [for subnet in aws_subnet.list_subnet_loop : subnet.cidr_block]
# }

# output "vpc_subnet_list_loop3" {
#   value = [for subnet in aws_subnet.list_subnet_loop : subnet.id]
# }

# output "vpc_subnet_cidr_loop2" {
#   value = { for k, subnet in aws_subnet.list_subnet_loop : subnet.id => subnet.cidr_block }
# }

# output "data-bucket-arn" {
#   value = data.aws_s3_bucket.data_bucket.arn
# }

# output "data-bucket-domain-name" {
#   value = data.aws_s3_bucket.data_bucket.bucket_domain_name
# }

# output "data-bucket-region" {
#   value = "The ${data.aws_s3_bucket.data_bucket.id} bucket is located in ${data.aws_s3_bucket.data_bucket.region}"
# }




