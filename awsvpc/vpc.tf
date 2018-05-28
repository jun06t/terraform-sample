# VPC

resource "aws_vpc" "vpc" {
  cidr_block = "172.17.0.0/16"

  tags {
    Name = "vpc"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw"
  }
}

# Public Subnets

resource "aws_subnet" "public_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "172.17.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1a"
  }
}

# Private Subnets

resource "aws_subnet" "private_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "172.17.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "0"

  tags {
    Name = "private-1a"
  }
}

# Public Subnet Association

resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

# Private Subnet Association

resource "aws_route_table_association" "private_1a" {
  subnet_id      = "${aws_subnet.private_1a.id}"
  route_table_id = "${aws_route_table.nat_rt.id}"
}
