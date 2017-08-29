terraform {
  required_version = "~> 0.10.0"
}

provider "aws" {
  version = "~> 0.1.3"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
