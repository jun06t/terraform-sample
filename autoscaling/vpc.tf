# VPC

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

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
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "public-1a"
  }
}

# Private Subnets

resource "aws_subnet" "private_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.100.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = "0"

  tags {
    Name = "private-1a"
  }
}

# Routes Table

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public-rt"
  }
}

resource "aws_route_table" "nat_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags {
    Name = "nat-rt"
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

# NAT Server
resource "aws_instance" "nat" {
  ami                         = "${var.amis.nat}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.nat.id}"]
  subnet_id                   = "${aws_subnet.public_1a.id}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "nat"
    Environment = "Common"
    Role        = "NAT"
  }
}
