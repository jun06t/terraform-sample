terraform {
  required_version = "~> 0.11.0"
}

provider "aws" {
  version = "~> 1.3.1"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
