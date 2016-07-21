resource "aws_security_group" "internal" {
    vpc_id = "${var.vpc_id}"
    name = "internal"
    description = "Allow internal traffic"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "internal"
    }
}

resource "aws_security_group" "nat" {
    vpc_id = "${var.vpc_id}"
    name = "nat"
    description = "Allow internal inbound traffic"
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "nat"
    }
}


resource "aws_security_group" "ssh" {
    vpc_id = "${var.vpc_id}"
    name = "ssh"
    description = "Allow ssh inbound traffic"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["122.212.216.66/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "ssh"
    }
}

resource "aws_security_group" "http" {
    vpc_id = "${var.vpc_id}"
    name = "http"
    description = "Allow http inbound traffic"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "http"
    }
}

