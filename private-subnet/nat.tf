# NAT Server
resource "aws_instance" "nat" {
  ami                         = "${var.amis["nat"]}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${module.security_group.nat_id}"]
  subnet_id                   = "${module.vpc.subnet_public_1a}"
  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "nat"
    Environment = "Common"
    Role        = "NAT"
  }
}

resource "aws_route_table" "nat_rt" {
  vpc_id = "${module.vpc.vpc_id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags {
    Name = "nat-rt"
  }
}

# Private Subnet Association

resource "aws_route_table_association" "private_1a" {
  subnet_id      = "${module.vpc.subnet_private_1a}"
  route_table_id = "${aws_route_table.nat_rt.id}"
}
