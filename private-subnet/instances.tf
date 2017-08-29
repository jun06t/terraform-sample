resource "aws_instance" "dev_api" {
  ami             = "${var.amis["api"]}"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${module.security_group.internal_id}"]
  subnet_id       = "${module.vpc.subnet_private_1a}"

  tags {
    Environment = "Development"
    Name        = "dev-api"
    Role        = "API"
  }
}
