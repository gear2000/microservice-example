output "alb_id" {
  value = "${aws_security_group.alb.id}"
}

output "instance_id" {
  value = "${aws_security_group.instance.id}"
}


