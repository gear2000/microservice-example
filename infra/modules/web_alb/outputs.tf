output "alb_id" {
  value = "${aws_alb.ecs-load-balancer.id}"
}

output "alb_arn" {
  value = "${aws_alb.ecs-load-balancer.arn}"
}

output "alb_dns_name" {
  value = "${aws_alb.ecs-load-balancer.dns_name}"
}

