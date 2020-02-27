# create ALB
resource "aws_alb" "ad-alb" {
  name            = "ad-alb"
  subnets         = [aws_subnet.ad-public-1.id, aws_subnet.ad-public-2.id, aws_subnet.ad-public-3.id]
  security_groups = [aws_security_group.lb_sg.id]
  enable_http2    = "true"
  idle_timeout    = 600
}

# setup listeners
resource "aws_alb_listener" "default_http" {
  load_balancer_arn = aws_alb.ad-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nginx.id
    type             = "forward"
  }
}

# setup ALB target group
resource "aws_alb_target_group" "nginx" {
  name       = "nginx"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.ad-vpc.id
  depends_on = [aws_alb.ad-alb]

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

output "alb_output" {
  value = aws_alb.ad-alb.dns_name
}

