variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-northeast-1"
}

variable "amis" {
  type = "map"

  default = {
    api = "ami-0011e566"
    nat = "ami-27d6e626"
  }
}

variable "key_name" {
  default = "YOUR_SSH_KEY"
}
