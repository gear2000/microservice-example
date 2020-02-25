# Provider
provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region     = "${var.vpc_region}"
}

# Network
module "vpc" {
  source = "./vpc"

  vpc_region     = "${var.vpc_region}"
  vpc_name       = "${var.vpc_name}"
  vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "subnet_public" {
  source = "./subnets/public"

  vpc_id      = "${module.vpc.id}"
  vpc_region  = "${module.vpc.region}"
  subnet_name = "${var.subnet_public}"
  subnet_cidr = "${var.subnet_public_cidr}"
  subnet_az   = "${var.subnet_public_az}"
}

module "subnet_private_01" {
  source = "./subnets/private"

  vpc_id      = "${module.vpc.id}"
  vpc_region  = "${module.vpc.region}"
  subnet_cidr = "${var.subnet_private_01_cidr}"
  subnet_name = "${var.subnet_private_01}"
  subnet_az   = "${var.subnet_private_01_az}"
}

module "subnet_private_02" {
  source = "./subnets/private"

  vpc_id      = "${module.vpc.id}"
  vpc_region  = "${module.vpc.region}"
  subnet_cidr = "${var.subnet_private_02_cidr}"
  subnet_name = "${var.subnet_private_02}"
  subnet_az   = "${var.subnet_private_02_az}"
}

module "nat_instance" {
  source            = "./nat"
  vpc_id            = "${module.vpc.id}"
  ami_id_nat        = "${var.ami_id_nat}"
  instance_type_nat = "${var.instance_type_nat}"

  subnet_public             = "${module.subnet_public.name}"
  subnet_public_id          = "${module.subnet_public.id}"
  subnet_public_az          = "${module.subnet_public.az}"
  subnet_public_private_key = "${module.subnet_public.private_key}"

  subnet_private_cidr_ranges = [
    "${var.subnet_private_01_cidr}",
    "${var.subnet_private_02_cidr}",
  ]

  subnet_private_01             = "${module.subnet_private_01.name}"
  subnet_private_01_rt_id       = "${module.subnet_private_01.route_table_id}"
  subnet_private_01_private_key = "${module.subnet_private_01.private_key}"

  subnet_private_02             = "${module.subnet_private_02.name}"
  subnet_private_02_rt_id       = "${module.subnet_private_02.route_table_id}"
  subnet_private_02_private_key = "${module.subnet_private_02.private_key}"
}

# Traffic Control
module "security_groups" {
  source = "./security_groups"

  vpc_id             = "${module.vpc.id}"
  vpc_region         = "${module.vpc.region}"
  sg_internal        = "${var.sg_internal}"
  sg_public          = "${var.sg_public}"
  subnet_public_cidr = "${var.subnet_public_cidr}"
}
