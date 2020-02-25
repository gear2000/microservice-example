output "vpc" {
  value = "${module.vpc.name}"
}

output "vpc_region" {
  value = "${module.vpc.region}"
}

# private subnet outputs
output "subnet_private_01" {
  value = "${module.subnet_private_01.name}"
}

output "subnet_private_01_id" {
  value = "${module.subnet_private_01.id}"
}

output "subnet_private_01_az" {
  value = "${var.subnet_private_01_az}"
}

output "subnet_private_01_key_name" {
  value = "${module.subnet_private_01.key_name}"
}

output "subnet_private_02" {
  value = "${module.subnet_private_02.name}"
}

output "subnet_private_02_id" {
  value = "${module.subnet_private_02.id}"
}

output "subnet_private_02_az" {
  value = "${var.subnet_private_02_az}"
}

output "subnet_private_02_key_name" {
  value = "${module.subnet_private_02.key_name}"
}

##############################################################
# public subnet outputs
##############################################################

output "subnet_public" {
  value = "${module.subnet_public.name}"
}

output "subnet_public_az" {
  value = "${module.subnet_public.az}"
}

output "subnet_public_id" {
  value = "${module.subnet_public.id}"
}

output "subnet_public_key_name" {
  value = "${module.subnet_public.key_name}"
}

output "security_group_internal" {
  value = "${var.sg_internal}"
}

output "security_group_internal_id" {
  value = "${module.security_groups.internal_id}"
}

output "security_group_public" {
  value = "${var.sg_public}"
}

output "security_group_public_id" {
  value = "${module.security_groups.public_id}"
}

output "nat_public_ip" {
  value = "${module.nat_instance.public_ip}"
}

output "nat_private_key" {
  sensitive = true
  value     = "${module.nat_instance.private_key}"
}
