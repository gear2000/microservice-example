# Autoscaling groups
resource "aws_autoscaling_group" "ad-cluster" {
  name                      = "ecs-example"
  vpc_zone_identifier       = var.subnets
  min_size                  = "2"
  max_size                  = "10"
  desired_capacity          = "2"
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  # zero-time deploy
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ad-cluster-asg"
    propagate_at_launch = true
  }
}

# Autoscaling criteria
resource "aws_autoscaling_policy" "ad-cluster" {
  name                      = "ad-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.ad-cluster.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix     = "launch_configuration"
  security_groups             = var.security_groups
  # key_name                  = "default"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile

  user_data = <<-EOF
                #!/bin/bash
                echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
                EOF

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
