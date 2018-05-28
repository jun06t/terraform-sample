terraform {
  required_version = "~> 0.11.7"
}

provider "aws" {
  version = "~> 1.19.0"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
