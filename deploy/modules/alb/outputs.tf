output "arn" {
  #value = aws_alb.ad-alb.arn
  value = aws_alb_target_group.app.id
}

output "dns_name" {
  value = aws_alb.ad-alb.dns_name
}

