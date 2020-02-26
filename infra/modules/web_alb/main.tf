resource "aws_alb" "ecs-load-balancer" {
  name                = "ecs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  enable_http2    = "true"
  idle_timeout    = 600

  security_groups      = var.security_groups
  subnets              = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "ecs-load-balancer"
  }
}

resource "aws_alb_target_group" "ecs" {
    name                = "ecs"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = var.vpc_id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
      Name = "ecs"
    }
}

resource "aws_alb_listener" "app" {
    load_balancer_arn = aws_alb.ecs-load-balancer.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.ecs.arn
        type             = "forward"
    }
}
