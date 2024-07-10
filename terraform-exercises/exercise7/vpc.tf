resource "aws_vpc" "boma-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "boma-vpc",
    Project = "terraform"
  }
}

resource "aws_subnet" "pub-sub1" {
  vpc_id     = aws_vpc.boma-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pub-sub1"
  }
}

resource "aws_subnet" "pub-sub2" {
  vpc_id     = aws_vpc.boma-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "pub-sub2"
  }
}

resource "aws_subnet" "priv-sub1" {
  vpc_id     = aws_vpc.boma-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "priv-sub1"
  }
}

resource "aws_subnet" "priv-sub2" {
  vpc_id     = aws_vpc.boma-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "priv-sub2"
  }
}

resource "aws_internet_gateway" "boma-gw" {
  vpc_id = aws_vpc.boma-vpc.id

  tags = {
    Name = "boma-gw"
  }
}

# resource "aws_internet_gateway_attachment" "gw-attachment" {
#   internet_gateway_id = aws_internet_gateway.boma-gw.id
#   vpc_id              = aws_vpc.boma-vpc.id
# }

resource "aws_route_table" "boma-pub-rt" {
  vpc_id = aws_vpc.boma-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.boma-gw.id
  }
}
resource "aws_route_table_association" "sub1-ass" {
  subnet_id      = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.boma-pub-rt.id
}
resource "aws_route_table_association" "sub2-ass" {
  subnet_id      = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.boma-pub-rt.id
}
# resource "aws_route_table_association" "priv1-ass" {
#   subnet_id      = aws_subnet.priv-sub1.id
#   route_table_id = aws_route_table.boma-pub-rt.id
# }
# resource "aws_route_table_association" "priv2-ass" {
#   subnet_id      = aws_subnet.priv-sub2.id
#   route_table_id = aws_route_table.boma-pub-rt.id
# }
