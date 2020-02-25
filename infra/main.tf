provider "aws" {
 profile    = "default"
 region  = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    App = "ms"
  }
}

resource "aws_security_group" "web" {
	name = "web"
	description = "Web Security Group"
    vpc_id = "${module.vpc.vpc_id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}		

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#resource "aws_alb" "ecs-load-balancer" {
#  name                = "ecs-load-balancer"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = ["$aws_security_group.web.id"]
#  subnets            = ["$module.vpc.public_subnets[0]","$module.vpc.public_subnets[1]"]
#
#  enable_deletion_protection = true
#
#  tags = {
#    Name = "ecs-load-balancer"
#  }
#}
#
#resource "aws_alb_target_group" "ecs-target-group" {
#    name                = "ecs-target-group"
#    port                = "80"
#    protocol            = "HTTP"
#    vpc_id              = "${module.vpc.vpc_id}"
#
#    health_check {
#        healthy_threshold   = "5"
#        unhealthy_threshold = "2"
#        interval            = "30"
#        matcher             = "200"
#        path                = "/"
#        port                = "traffic-port"
#        protocol            = "HTTP"
#        timeout             = "5"
#    }
#
#    tags = {
#      Name = "ecs-target-group"
#    }
#}

##resource "aws_alb_listener" "alb-listener" {
##    load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
##    port              = "80"
##    protocol          = "HTTP"
##
##    default_action {
##        target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
##        type             = "forward"
##    }
##}
