resource "aws_instance" "dev_api" {
    ami = "${var.amis.api}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.internal.id}"]
    subnet_id = "${aws_subnet.private_1a.id}"
    tags {
        Environment = "Development"
        Name = "dev-api"
        Role = "API"
    }
}
