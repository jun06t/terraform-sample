module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr_block = "${module.vpc.cidr_block}"
}
