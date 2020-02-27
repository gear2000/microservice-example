# internet VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "172.21.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
}

# subnets
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2b"
}

resource "aws_subnet" "public-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2c"
}

resource "aws_subnet" "private-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.40.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"
}

resource "aws_subnet" "private-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.50.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2b"
}

resource "aws_subnet" "private-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.21.60.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2c"
}

# internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

## route tables
#resource "aws_route_table" "public" {
#  vpc_id = aws_vpc.vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gw.id
#  }
#}
#
## route associations public
#resource "aws_route_table_association" "public-1-a" {
#  subnet_id      = aws_subnet.public-1.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "public-2-a" {
#  subnet_id      = aws_subnet.public-2.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "public-3-a" {
#  subnet_id      = aws_subnet.public-3.id
#  route_table_id = aws_route_table.public.id
#}

# route tables
resource "aws_route_table" "demo-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# route associations public
resource "aws_route_table_association" "demo-public-1-a" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.demo-public.id
}

resource "aws_route_table_association" "demo-public-2-a" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.demo-public.id
}

resource "aws_route_table_association" "demo-public-3-a" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.demo-public.id
}

