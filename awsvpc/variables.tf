variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-northeast-1"
}

variable "amis" {
  default = {
    ecs = "ami-f3f8098c"
  }
}

variable "key_name" {
  default = "awsvpc"
}
