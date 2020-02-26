output "alb_id" {
  value = "${aws_alb.ecs-load-balancer.id}"
}

output "alb_arn" {
  value = "${aws_alb.ecs-load-balancer.arn}"
}
