output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}

output "cidr_block" {
    value = "${aws_vpc.vpc.cidr_block}"
}

output "subnet_private_1a" {
    value = "${aws_subnet.private_1a.id}"
}

output "subnet_public_1a" {
    value = "${aws_subnet.public_1a.id}"
}
