# create ALB
resource "aws_alb" "ad-alb" {
  name            = "ad-alb"

  security_groups      = var.security_groups
  subnets              = var.subnets
  enable_deletion_protection = false
  enable_http2    = "true"
  idle_timeout    = 300
}

# setup listeners
resource "aws_alb_listener" "default_http" {
  load_balancer_arn = aws_alb.ad-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

# setup ALB target group
resource "aws_alb_target_group" "app" {
  name       = "app"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc_id

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
