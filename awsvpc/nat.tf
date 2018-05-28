resource "aws_eip" "nat_1a" {
  vpc = true
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = "${aws_eip.nat_1a.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"

  tags {
    Name        = "nat-1a"
    Environment = "Test"
    Type        = "NATGateway"
  }
}
