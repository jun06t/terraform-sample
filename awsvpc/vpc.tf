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
  cidr_block              = "172.17.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "172.17.20.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1c"
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

