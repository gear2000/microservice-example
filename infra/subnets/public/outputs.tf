output "id" {
  value = "${aws_subnet.public.id}"
}

output "name" {
  value = "${var.subnet_name}"
}

output "az" {
  value = "${var.subnet_az}"
}

output "key_name" {
  value = "${aws_key_pair.key_pair.key_name}"
}

output "public_key" {
  value = "${aws_key_pair.key_pair.public_key}"
}

output "private_key" {
  value     = "${tls_private_key.private_key.private_key_pem}"
  sensitive = true
}
