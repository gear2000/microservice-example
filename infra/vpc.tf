### Network

# Internet VPC

resource "aws_vpc" "ad-vpc" {
  cidr_block           = "172.21.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "ad-vpc"
  }
}

# Subnets
resource "aws_subnet" "ad-public-1" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "ad-public-1"
  }
}

resource "aws_subnet" "ad-public-2" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "ad-public-2"
  }
}

resource "aws_subnet" "ad-public-3" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2c"

  tags = {
    Name = "ad-public-3"
  }
}

resource "aws_subnet" "ad-private-1" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.40.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "ad-private-1"
  }
}

resource "aws_subnet" "ad-private-2" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.50.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "ad-private-2"
  }
}

resource "aws_subnet" "ad-private-3" {
  vpc_id                  = aws_vpc.ad-vpc.id
  cidr_block              = "172.21.60.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2c"

  tags = {
    Name = "ad-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "ad-gw" {
  vpc_id = aws_vpc.ad-vpc.id

  tags = {
    Name = "ad-IG"
  }
}

# route tables
resource "aws_route_table" "ad-public" {
  vpc_id = aws_vpc.ad-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ad-gw.id
  }

  tags = {
    Name = "ad-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "ad-public-1-a" {
  subnet_id      = aws_subnet.ad-public-1.id
  route_table_id = aws_route_table.ad-public.id
}

resource "aws_route_table_association" "ad-public-2-a" {
  subnet_id      = aws_subnet.ad-public-2.id
  route_table_id = aws_route_table.ad-public.id
}

resource "aws_route_table_association" "ad-public-3-a" {
  subnet_id      = aws_subnet.ad-public-3.id
  route_table_id = aws_route_table.ad-public.id
}

